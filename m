Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752389Ab1HOLmK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Aug 2011 07:42:10 -0400
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:61294 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751634Ab1HOLmH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Aug 2011 07:42:07 -0400
Date: Mon, 15 Aug 2011 12:41:47 +0100
From: Catalin Marinas <catalin.marinas@arm.com>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: Vasily Khoruzhick <anarsoul@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH] Fix non-LPAE boot regression.
Message-ID: <20110815114146.GA21596@e102109-lin.cambridge.arm.com>
References: <201108131556.27301.anarsoul@gmail.com>
 <1313240299-24712-1-git-send-email-anarsoul@gmail.com>
 <CAHkRjk4p1kqwKGiW_XRFU0aap98QkvRGRs0hwsBR4CcfM5RKqA@mail.gmail.com>
 <20110813143903.GQ4775@n2100.arm.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110813143903.GQ4775@n2100.arm.linux.org.uk>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Aug 13, 2011 at 03:39:03PM +0100, Russell King - ARM Linux wrote:
> I think this patch is trying to do too much in one go.  It needs splitting
> up into two, just like is done with the C PGDIR_SHIFT vs PMD_SHIFT stuff
> (and arguably the first part should be combined with the patch fixing the
> PGDIR_SHIFT stuff.)

OK, I'll do this and repost the two patches in reply to this one (and
merge one of them with the PMD_SHIFT but I would avoid reposting the
full series again).

For patch clarity, I'll fold Vasily's fix as well rather than keeping it
in a separate patch.

-- 
Catalin
