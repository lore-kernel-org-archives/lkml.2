Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757216Ab0HCRHz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Aug 2010 13:07:55 -0400
Received: from smtp.outflux.net ([198.145.64.163]:54147 "EHLO smtp.outflux.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756799Ab0HCRHx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Aug 2010 13:07:53 -0400
Date: Tue, 3 Aug 2010 10:07:49 -0700
From: Kees Cook <kees.cook@canonical.com>
To: Christian Stroetmann <stroetmann@ontolinux.com>
Cc: James Morris <jmorris@namei.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        linux-security-module <linux-security-module@vger.kernel.org>
Subject: Re: Preview of changes to the Security susbystem for 2.6.36
Message-ID: <20100803170749.GI3948@outflux.net>
References: <alpine.LRH.2.00.1007301852110.14431@tundra.namei.org>
 <alpine.LRH.2.00.1008021216520.31941@tundra.namei.org>
 <20100802063224.GR3948@outflux.net>
 <alpine.LRH.2.00.1008021639230.32603@tundra.namei.org>
 <20100802065746.GS3948@outflux.net>
 <4C569BCA.3050603@ontolinux.com>
 <20100802163602.GU3948@outflux.net>
 <4C570166.8050105@ontolinux.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4C570166.8050105@ontolinux.com>
Organization: Canonical
X-HELO: www.outflux.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 02, 2010 at 07:33:26PM +0200, Christian Stroetmann wrote:
> structure of the other LSMs, especially if it becomes large and in
> this way important to be followed by only growing it with
> functionalities taken from other security packages. If you say that
> the way of the Yama LSM is the right way to do it in general, then
> we don't need a new LSM like Yama, but a new LSM architecture.

Well, trying to get these protections into mainline does seem to be
demonstrating a need for some kind of security architecture that isn't LSM.

As for chaining, I was considering introducing basic "first non-zero return
code wins" chain of LSMs, but the chain could include only up to 1 LSM that
implements the proc attr hook (though the prctl handler isn't non-zero but
rather non-ENOSYS).

-Kees

-- 
Kees Cook
Ubuntu Security Team
