Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752587Ab2GRJNs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jul 2012 05:13:48 -0400
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:43782 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751868Ab2GRJNn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jul 2012 05:13:43 -0400
Date: Wed, 18 Jul 2012 10:13:24 +0100
From: Catalin Marinas <catalin.marinas@arm.com>
To: Jon Masters <jonathan@jonmasters.org>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Arnd Bergmann <arnd@arndb.de>
Subject: Re: [PATCH 00/36] AArch64 Linux kernel port
Message-ID: <20120718091324.GB23190@arm.com>
References: <1341608777-12982-1-git-send-email-catalin.marinas@arm.com>
 <50064B2C.4070207@jonmasters.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <50064B2C.4070207@jonmasters.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jon,

On Wed, Jul 18, 2012 at 06:35:40AM +0100, Jon Masters wrote:
> On 07/06/2012 05:05 PM, Catalin Marinas wrote:
> 
> > These patches are also available on this branch:
> > 
> > git://git.kernel.org/pub/scm/linux/kernel/git/cmarinas/linux-aarch64.git upstream
> 
> What's your general plan for tracking development with this branch?

The "upstream" branch is rebased according to the feedback I receive and
it will match the patches that I post on LKML.

For development, the "master" branch on that tree is never rebased, so
you can see the changes added since the first version (currently only
two published). It is however kept in sync with the rebased branch (so
there shouldn't be any diff between them).

Both of them will track the latest mainline (though not daily).

-- 
Catalin
