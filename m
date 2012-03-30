Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760532Ab2C3JMB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Mar 2012 05:12:01 -0400
Received: from s15943758.onlinehome-server.info ([217.160.130.188]:41296 "EHLO
	mail.x86-64.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759788Ab2C3JLy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Mar 2012 05:11:54 -0400
Date: Fri, 30 Mar 2012 11:11:46 +0200
From: Borislav Petkov <bp@amd64.org>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Greg K H <gregkh@linuxfoundation.org>,
        Linux Edac Mailing List <linux-edac@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 01/14] edac: rewrite the sysfs code to use struct device
Message-ID: <20120330091146.GB29854@aftab>
References: <1333040821-6253-1-git-send-email-mchehab@redhat.com>
 <1333040821-6253-2-git-send-email-mchehab@redhat.com>
 <20120329220300.GA16491@kroah.com>
 <4F74EDEC.5020804@redhat.com>
 <20120329234037.GA16094@kroah.com>
 <4F7516B3.8070505@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4F7516B3.8070505@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 29, 2012 at 11:13:07PM -0300, Mauro Carvalho Chehab wrote:
> However, every time this patch series is submitted, someone come up with a 
> bright idea to ask me to add more work to the scope, delaying its addition 
> forever.
> 
> While I'm not convinced that moving from a single memory allocation into a 
> series of k*alloc is a good thing for a subsystem that is there to detect
> memory errors (as having everything altogether into a single page can
> reduce the chances of errors at the EDAC data), I can work latter on a 
> patchset to fix this issue for EDAC MC, but I'll do it only after merging 
> this series, as it is counter-productive to do it otherwise, having to 
> repeat the same set of tests on 10 machines (and compile the entire series 
> of patches on 8 different archs/sub-archs).
> 
> So, I really want to move this ahead. So, please, first things first: let's
> first fix the more serious bug. Then, we can fix the other minor stuff
> that aren't so far causing any noticeable harm.

Dude, stop complaining - this is the kernel not some pet project of
yours. You either do things right or you don't do them at all. Others
have to do the same iterations with patches and intergrate maintainer
change requests until everything is done properly.

Btw, this patch is

 5 files changed, 432 insertions(+), 717 deletions(-)

It is 1500+ lines and huuuuge! How do you think anyone can review this?

Also, I told already: if you wanna fix one thing, then fix it with a
smaller patchset which easier to review by people instead of throwing at
them humongous patch bombs which are supposed to fix _everything_ and
expecting everyone to understand immediately what you mean. And don't
tell me these huge patches cannot be split, I'm not buying it.

-- 
Regards/Gruss,
Boris.

Advanced Micro Devices GmbH
Einsteinring 24, 85609 Dornach
GM: Alberto Bozzo
Reg: Dornach, Landkreis Muenchen
HRB Nr. 43632 WEEE Registernr: 129 19551
