Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752839Ab1DAW4p (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Apr 2011 18:56:45 -0400
Received: from smtp.eu.citrix.com ([62.200.22.115]:10115 "EHLO
	SMTP.EU.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752120Ab1DAW4o (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Apr 2011 18:56:44 -0400
X-IronPort-AV: E=Sophos;i="4.63,284,1299456000"; 
   d="scan'208";a="5103787"
Date: Fri, 1 Apr 2011 23:57:24 +0100
From: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
X-X-Sender: sstabellini@kaball-desktop
To: Ingo Molnar <mingo@elte.hu>
CC: Stefano Stabellini <Stefano.Stabellini@eu.citrix.com>,
        "H. Peter Anvin" <hpa@zytor.com>, "x86@kernel.org" <x86@kernel.org>,
        "yinghai@kernel.org" <yinghai@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Greg KH <gregkh@suse.de>,
        "lkml20101129@newton.leun.net" <lkml20101129@newton.leun.net>,
        stable kernel team <stable@kernel.org>
Subject: Re: [PATCH urgent] x86: Save cr4 to mmu_cr4_features at boot time
In-Reply-To: <20110401190812.GA16830@elte.hu>
Message-ID: <alpine.DEB.2.00.1104012318390.16492@kaball-desktop>
References: <alpine.DEB.2.00.1103311715400.16492@kaball-desktop> <20110401062338.GA6434@elte.hu> <alpine.DEB.2.00.1104011212070.16492@kaball-desktop> <20110401190812.GA16830@elte.hu>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 1 Apr 2011, Ingo Molnar wrote:
> * Stefano Stabellini <stefano.stabellini@eu.citrix.com> wrote:
> > I asked for a backport of e5f15b45ddf3afa2bbbb10c7ea34fb32b6de0a0e to the 
> > stable trees because I forgot to add "CC stable@kernel.org" to the commit 
> > message and this commit is needed to fix a critical crash on boot on xen.
> 
> You are displaying a dangerously amateurish attitude towards quality control 
> and you clealy have no idea what it takes to push fixes into -stable.
> 
> You forwarded a brand-new, visibly dangerous native kernel commit to -stable 
> without Cc:-ing the maintainers and you have caused a native kernel regression 
> that way. You are not maintaining the code in question and you have not 
> committed the patch in question.


Just to clarify the situation the patch "x86-64: finish
cleanup_highmaps()'s job wrt. _brk_end" was backported to the stable
trees (including Jeremy's 2.6.32 xen tree because he pulled from
2.6.32.y) breaking boot on xen.
Yinghai's patch plus another patch of mine fix that breakage and that is
why I ask for it to be backported.
I didn't mean for the backport to be done right now, I just wanted to
notify the stable maintainers that the particular commit should be
backported at some point.

I didn't mean to overstep your authority in any way.
I know that ignorance is never an excuse but I am still new to this and
my knowledge of how the process works is limited to a blog entry by Greg
KH from an year ago.
I realize that stable trees are really important so I am very sorry to
have introduced such an important breakage.
