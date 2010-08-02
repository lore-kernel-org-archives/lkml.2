Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754192Ab0HBQgL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Aug 2010 12:36:11 -0400
Received: from smtp.outflux.net ([198.145.64.163]:53033 "EHLO smtp.outflux.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751102Ab0HBQgJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Aug 2010 12:36:09 -0400
Date: Mon, 2 Aug 2010 09:36:02 -0700
From: Kees Cook <kees.cook@canonical.com>
To: Christian Stroetmann <stroetmann@ontolinux.com>
Cc: James Morris <jmorris@namei.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        linux-security-module <linux-security-module@vger.kernel.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>
Subject: Re: Preview of changes to the Security susbystem for 2.6.36
Message-ID: <20100802163602.GU3948@outflux.net>
References: <alpine.LRH.2.00.1007301852110.14431@tundra.namei.org>
 <alpine.LRH.2.00.1008021216520.31941@tundra.namei.org>
 <20100802063224.GR3948@outflux.net>
 <alpine.LRH.2.00.1008021639230.32603@tundra.namei.org>
 <20100802065746.GS3948@outflux.net>
 <4C569BCA.3050603@ontolinux.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4C569BCA.3050603@ontolinux.com>
Organization: Canonical
X-HELO: www.outflux.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Christian,

On Mon, Aug 02, 2010 at 12:19:54PM +0200, Christian Stroetmann wrote:
> But we discussed as well that the problem of chaining of small or
> large LSMs is not an argument for the existence of the Yama LSM, and
> that the LSM architecture should be developed further so that all of
> the functionalities of other securtiy packages without an LSM can be
> integrated as a whole by a new version of the LSM system in the
> future and not by ripping them of like it was done with the Yama LSM
> [3].
> You can see these objections [3] as a second NAK, but now from a
> company's developer (I haven't said this before, because I'm not a
> hard core kernel developer).

I'm not sure I understand you, exactly. Are you saying that Yama should not
exist because it might grow into a large LSM?

-Kees

-- 
Kees Cook
Ubuntu Security Team
