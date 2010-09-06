Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751403Ab0IFE4q (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Sep 2010 00:56:46 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:56939 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751170Ab0IFE4c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Sep 2010 00:56:32 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=FbajGsVhnf17N3m5HhWpcS29kCvO3sgB8OTXot21aJgrIroV0Ewb3QQaXBMWHSAev3
         0vOgOtfJupkrowHt26x+JYrsx4OvHV68l8yZHwC2VdlWv7SlgrJGVuDaOiBJk8YFQnNk
         a9bfgRG6DyOmAy0QtM3lmwLPFiScVeraTRVpk=
Date: Sun, 5 Sep 2010 21:56:26 -0700
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Cc: Vladislav Bolkhovitin <vst@vlnb.net>,
        James Bottomley <James.Bottomley@suse.de>,
        Dirk Meister <dmeister@uni-paderborn.de>, linux-scsi@vger.kernel.org,
        Chetan Loke <chetanloke@gmail.com>,
        Chetan Loke <generationgnu@yahoo.com>,
        scst-devel <scst-devel@lists.sourceforge.net>,
        linux-kernel@vger.kernel.org, Mike Christie <michaelc@cs.wisc.edu>,
        FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: Re: [Scst-devel] Fwd: Re: linuxcon 2010...
Message-ID: <20100906045625.GB17212@core.coreip.homeip.net>
References: <4C79484B.3090607@vlnb.net>
 <1283028468.32007.357.camel@haakon2.linux-iscsi.org>
 <4C7C18CE.5020103@vlnb.net>
 <1283204792.32007.448.camel@haakon2.linux-iscsi.org>
 <4C7FFD1A.8090509@vlnb.net>
 <1283459158.5598.143.camel@haakon2.linux-iscsi.org>
 <20100905201802.GC18411@core.coreip.homeip.net>
 <1283723447.556.133.camel@haakon2.linux-iscsi.org>
 <20100905234134.GA17212@core.coreip.homeip.net>
 <1283731194.556.147.camel@haakon2.linux-iscsi.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1283731194.556.147.camel@haakon2.linux-iscsi.org>
User-Agent: Mutt/1.5.20 (2009-12-10)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Sep 05, 2010 at 04:59:54PM -0700, Nicholas A. Bellinger wrote:
> On Sun, 2010-09-05 at 16:41 -0700, Dmitry Torokhov wrote:
> > On Sun, Sep 05, 2010 at 02:50:47PM -0700, Nicholas A. Bellinger wrote:
> > > Anyways, if we are going to compare SCM distributed vs. centralized
> > > workflow in terms of kernel projects, lets please at least compare
> > > apples to apples here.
> > > 
> > 
> > No, we should not be comparing SCMs at all here but rather 2 competing
> > implementations based on quality of the code. You tried to bring SMC
> > angle in and I am saying that it is BS.
> > 
> 
> Again, without getting into another pointless flamewar,  I think the
> main point here is that a open source project using a distributed
> workflow (like git) has major advantages when it comes to working with a
> larger group of developers than a centralized model (like SVN) does.
> 
> Because being a subsystem maintainer typically involves this type of
> complex workflow involving lots of different parties, git is a tool that
> was created (originally) expressely for a kernel workflow, and for those
> types of people it works really, really well.
> 

You may be surprised but I am aware of subsystem maintainer workflow. I
also am aware that there is not a single workflow and that it varies by
maintainer. For some git is indeed the best tool but others (and I
named a few) might prefer something different.

Once again: should we declare all subsystems that do not use git as
primary SCM be inferior and drop them from the kernel?

> So, please understand that code and project workflow is only one of the
> reasons why TCM/LIO v4 was selected over SCST.   I invite you to take a
> closer look at the RFC Code that has been posted last week if you want
> to get into the nitty-gritty techinical details, which this thread has
> thus far been avoiding.

Yes, I agree that it would be much more productive if you concentrated
on technical details when answering Vlad's questions rather than
branching into immaterial argument over SCM choice.

-- 
Dmitry
