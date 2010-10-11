Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756609Ab0JKWBE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Oct 2010 18:01:04 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:54963 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756400Ab0JKWBD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Oct 2010 18:01:03 -0400
Date: Mon, 11 Oct 2010 14:59:30 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Michal Marek <mmarek@suse.cz>
Cc: Catalin Marinas <catalin.marinas@arm.com>, linux-kbuild@vger.kernel.org,
        sfr@canb.auug.org.au, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, lacombar@gmail.com,
        xiyou.wangcong@gmail.com
Subject: Re: [PATCH] kconfig: Temporarily disable dependency warnings
Message-Id: <20101011145930.11fe570c.randy.dunlap@oracle.com>
In-Reply-To: <4CB385C8.7010109@suse.cz>
References: <20101008150343.GF4088@hack>
	<1286660701-31557-1-git-send-email-mmarek@suse.cz>
	<1286810580.19739.108.camel@e102109-lin.cambridge.arm.com>
	<4CB385C8.7010109@suse.cz>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.6; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 11 Oct 2010 23:46:48 +0200 Michal Marek wrote:

> On 11.10.2010 17:23, Catalin Marinas wrote:
> > On Sat, 2010-10-09 at 22:45 +0100, Michal Marek wrote:
> >> After fixing a use-after-free bug in kconfig, a 'make defconfig' or
> >> 'make allmodconfig' fills the screen with warnings that were not
> >> detected before. Given that we are close to the release now, disable the
> >> warnings temporarily and deal with them after 2.6.36.
> >>
> >> Signed-off-by: Michal Marek <mmarek@suse.cz>
> > 
> > Acked-by: Catalin Marinas <catalin.marinas@arm.com>
> 
> Thanks, but I already pushed it on Saturday. The good news is that Linus
> did pull from me, so 2.6.36 will have this.


Was it disabled (i.e., this patch applied) in linux-next 20101011?
Seems to be -- I see no warnings.
Can you undo that now so that warnings are back, please?

---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
