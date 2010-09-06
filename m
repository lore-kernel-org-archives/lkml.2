Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755032Ab0IFA6r (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Sep 2010 20:58:47 -0400
Received: from mail-gy0-f174.google.com ([209.85.160.174]:59488 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754557Ab0IFA6q convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Sep 2010 20:58:46 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=hOAJpJJmefIvP45u4XrDReHqLGaFyDCJzae98SfYpvoUSfVhuT/uRsO32cgkZbbKvc
         dbCda/lZ3/NPo1LMb1wwa83Et2EuRcSAgm/uo8zC3QmV9SDVtsYVc61UkG2xaVmH0sSV
         QGZDHulIMTHrD4/+5g3BaQq8txsKyr7uJF1Wo=
MIME-Version: 1.0
In-Reply-To: <1283731939.556.159.camel@haakon2.linux-iscsi.org>
References: <4C7421FB.2060007@vlnb.net> <1282685014.32007.51.camel@haakon2.linux-iscsi.org>
 <4C76CA57.3050405@vlnb.net> <1282857806.32007.175.camel@haakon2.linux-iscsi.org>
 <4C79484B.3090607@vlnb.net> <1283028468.32007.357.camel@haakon2.linux-iscsi.org>
 <4C7C18CE.5020103@vlnb.net> <1283204792.32007.448.camel@haakon2.linux-iscsi.org>
 <4C7FFD1A.8090509@vlnb.net> <1283459158.5598.143.camel@haakon2.linux-iscsi.org>
 <20100905201802.GC18411@core.coreip.homeip.net> <1283723447.556.133.camel@haakon2.linux-iscsi.org>
 <AANLkTimdHotxVS8ZJJhg0D08FUiw4scSMTb2dryqJ_vQ@mail.gmail.com> <1283731939.556.159.camel@haakon2.linux-iscsi.org>
From: Mark Deneen <mdeneen@gmail.com>
Date: Sun, 5 Sep 2010 20:58:23 -0400
Message-ID: <AANLkTikOgc+YbkzmOpJv=s4Oxj9S9LYQ5qf5jDbT0ycg@mail.gmail.com>
Subject: Re: [Scst-devel] Fwd: Re: linuxcon 2010...
To: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Mike Christie <michaelc@cs.wisc.edu>,
        Vladislav Bolkhovitin <vst@vlnb.net>, linux-scsi@vger.kernel.org,
        Chetan Loke <chetanloke@gmail.com>, linux-kernel@vger.kernel.org,
        FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>,
        James Bottomley <James.Bottomley@suse.de>,
        scst-devel <scst-devel@lists.sourceforge.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Hi Mark,
>
> I will always be advocating using the best tool for the job in any given
> situation.  So absoulutely, I would have picked bitkeeper over tarballs
> any day of the week 7 years ago, or over SVN if it had existed back
> then.

I can't say that I agree with this.  SVN existed, along with many
other open source choices -- the choice of BitKeeper was a mistake.

> But again, I think it's an important point that git is a tool that was
> made explictly for the linux kernel workflow.  Why would a new subsystem
> maintainer is participates in the kernel workflow ever use anything
> besides git at this point..?

Look, I'm not saying that I dislike git.  I use it as my SCM here.
However, git was in its infancy (or not even around) when SCST was
started.  It's not like they had a proprietary vendor go cold turkey
on them, forcing everyone to another solution.

> And sorry, but considering the obvious advantages in terms of workflow
> speed and flexibility that git brings to the table for a subsystem
> maintainer, calling the choise of SCM a nit-pick item demonstrates a
> level certain level of inexperience wrt to mainline kernel workflow.
> Which is perfectly OK, but if you really want to understand the issues
> at hand in a distributed vs. centrailized SCM model, I strongly suggest
> you watch Linus's talk as well.
>
> Best,
>
> --nab

I'm still calling it a nit-pick.  Vlad could switch to git in a short
amount of time if he felt so compelled.  This is like saying that the
quality of a car is based on the style of garage it is parked in.

Kind Regards,
Mark Deneen
