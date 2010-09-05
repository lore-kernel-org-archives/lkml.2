Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754850Ab0IEXOO (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Sep 2010 19:14:14 -0400
Received: from mail-vw0-f46.google.com ([209.85.212.46]:53703 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754563Ab0IEXON convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Sep 2010 19:14:13 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=dDQBxRKcoH1hhrmMiIFD84JL7jI0gXRB2sPOMF97OIBjGPmH/pmLZdyrxT7VUF27QK
         cWfATf9Z7cXAHnBsEWczxr2BjigqKapN5hxOLb2J4kFuFg1nsxExhVUCUPaJyWRR32YZ
         5e7lqMMYVHv1f1SMsestvAuhFc2QgRaPChnn4=
MIME-Version: 1.0
In-Reply-To: <1283723447.556.133.camel@haakon2.linux-iscsi.org>
References: <4C7421FB.2060007@vlnb.net> <1282685014.32007.51.camel@haakon2.linux-iscsi.org>
 <4C76CA57.3050405@vlnb.net> <1282857806.32007.175.camel@haakon2.linux-iscsi.org>
 <4C79484B.3090607@vlnb.net> <1283028468.32007.357.camel@haakon2.linux-iscsi.org>
 <4C7C18CE.5020103@vlnb.net> <1283204792.32007.448.camel@haakon2.linux-iscsi.org>
 <4C7FFD1A.8090509@vlnb.net> <1283459158.5598.143.camel@haakon2.linux-iscsi.org>
 <20100905201802.GC18411@core.coreip.homeip.net> <1283723447.556.133.camel@haakon2.linux-iscsi.org>
From: Mark Deneen <mdeneen@gmail.com>
Date: Sun, 5 Sep 2010 19:13:52 -0400
Message-ID: <AANLkTimdHotxVS8ZJJhg0D08FUiw4scSMTb2dryqJ_vQ@mail.gmail.com>
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

On Sun, Sep 5, 2010 at 5:50 PM, Nicholas A. Bellinger
<nab@linux-iscsi.org> wrote:
>
> I think the difference between what Linus says and what he actually
> means in the above video could be easily misinterpreted, well especially
> for some non-english speaking folks.  But I am certainly glad to see
> that a russian translation is also available for this google git talk
> for those who really want try to understand his reasons (and technical
> requirements) for what he is saying.
>
> So as to the specifics about why git is really the only right SCM choice
> for mainline target mode maintainership, it really all comes down to
> workflow.  Does your SCM allow other people to easily and without-pain
> track your upstream subsystem tree changes and 'rebase' as necessary for
> their patch series you make improvements..?   If we are talking about
> say, a single standalone driver being developed against mainline, then
> sure using a SCM like CVS or SVN is perfectly acceptable when you push
> to someone upstream like gregkh or akpm via email patch attachments.
>
> However, if we are talking about a subsystem maintainer workflow that
> requires many different people to track your subsystem tree for their
> own drivers and new feature bits, not being able to keep local branches
> for these level developers makes their life excruciatingly painful and
> unpleasent as they attempt to pull new upstream changes, especially when
> the speed of new upstream development is moving quickly.  This rule
> applys even more when said subsystem has a greater scope within the
> source tree in question.
>
> Anyways, if we are going to compare SCM distributed vs. centralized
> workflow in terms of kernel projects, lets please at least compare
> apples to apples here.
>
> Best,
>
> --nab

I've been trying to keep my 2 cents out of this, as I am merely an
SCST user.  Both of you have valid criticisms; the choice of SCM is
not one of them.  It is nit-picking at best, especially when SCST
could switch to git easily if they so desired.

Seven years ago, would you be pushing BitKeeper?

Kind Regards,
Mark Deneen
