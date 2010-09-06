Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754951Ab0IFAQU (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Sep 2010 20:16:20 -0400
Received: from smtp102.sbc.mail.ne1.yahoo.com ([98.138.84.213]:39376 "HELO
	smtp102.sbc.mail.ne1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1754922Ab0IFAQS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Sep 2010 20:16:18 -0400
X-Yahoo-SMTP: fzDSGlOswBCWnIOrNw7KwwK1j9PqyNbe5PtLKiS4dDU.UNl_t6bdEZu9tTLW
X-YMail-OSG: 7jATH4IVM1mXO_fh0NpCGFA8G69oroIZnm_cX1rf7LuobH9
 4BhC0jYbsmux.3.4lFyMarGGbaR.zK.udS2B6KXBz0nI6_L64O7iHpjBvNq6
 Baf75bXc8AV9ghSs.YDFJoBe85Ph1D9Ys0AopeljmRiW4fUVYOlYOvFRfX3X
 Gjkcyv5hQVAnntzZFucY12Gd4B6GEVYsgAhDiuaaU0aySA2PgOAy8avV88Yg
 HZRNu10GDpxzLG2RoNPC1tJT5eVAGVJD7SoBGyL3RmaiKVi6BqVd9uwjwMpE
 G6YMCIxhyUv9qiJ0dTqb6AXOxtNXO7q0atjBzoLVMu8Ap1uhw5MoZZjm2fAS
 ELjdox._c.mo3k4Levg--
X-Yahoo-Newman-Property: ymail-3
Subject: Re: [Scst-devel] Fwd: Re: linuxcon 2010...
From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
To: Mark Deneen <mdeneen@gmail.com>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Mike Christie <michaelc@cs.wisc.edu>,
        Vladislav Bolkhovitin <vst@vlnb.net>, linux-scsi@vger.kernel.org,
        Chetan Loke <chetanloke@gmail.com>, linux-kernel@vger.kernel.org,
        FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>,
        James Bottomley <James.Bottomley@suse.de>,
        scst-devel <scst-devel@lists.sourceforge.net>
In-Reply-To: <AANLkTimdHotxVS8ZJJhg0D08FUiw4scSMTb2dryqJ_vQ@mail.gmail.com>
References: <4C7421FB.2060007@vlnb.net>
	 <1282685014.32007.51.camel@haakon2.linux-iscsi.org>
	 <4C76CA57.3050405@vlnb.net>
	 <1282857806.32007.175.camel@haakon2.linux-iscsi.org>
	 <4C79484B.3090607@vlnb.net>
	 <1283028468.32007.357.camel@haakon2.linux-iscsi.org>
	 <4C7C18CE.5020103@vlnb.net>
	 <1283204792.32007.448.camel@haakon2.linux-iscsi.org>
	 <4C7FFD1A.8090509@vlnb.net>
	 <1283459158.5598.143.camel@haakon2.linux-iscsi.org>
	 <20100905201802.GC18411@core.coreip.homeip.net>
	 <1283723447.556.133.camel@haakon2.linux-iscsi.org>
	 <AANLkTimdHotxVS8ZJJhg0D08FUiw4scSMTb2dryqJ_vQ@mail.gmail.com>
Content-Type: text/plain
Date: Sun, 05 Sep 2010 17:12:19 -0700
Message-Id: <1283731939.556.159.camel@haakon2.linux-iscsi.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2010-09-05 at 19:13 -0400, Mark Deneen wrote:
> On Sun, Sep 5, 2010 at 5:50 PM, Nicholas A. Bellinger
> <nab@linux-iscsi.org> wrote:
> >
> > I think the difference between what Linus says and what he actually
> > means in the above video could be easily misinterpreted, well especially
> > for some non-english speaking folks.  But I am certainly glad to see
> > that a russian translation is also available for this google git talk
> > for those who really want try to understand his reasons (and technical
> > requirements) for what he is saying.
> >
> > So as to the specifics about why git is really the only right SCM choice
> > for mainline target mode maintainership, it really all comes down to
> > workflow.  Does your SCM allow other people to easily and without-pain
> > track your upstream subsystem tree changes and 'rebase' as necessary for
> > their patch series you make improvements..?   If we are talking about
> > say, a single standalone driver being developed against mainline, then
> > sure using a SCM like CVS or SVN is perfectly acceptable when you push
> > to someone upstream like gregkh or akpm via email patch attachments.
> >
> > However, if we are talking about a subsystem maintainer workflow that
> > requires many different people to track your subsystem tree for their
> > own drivers and new feature bits, not being able to keep local branches
> > for these level developers makes their life excruciatingly painful and
> > unpleasent as they attempt to pull new upstream changes, especially when
> > the speed of new upstream development is moving quickly.  This rule
> > applys even more when said subsystem has a greater scope within the
> > source tree in question.
> >
> > Anyways, if we are going to compare SCM distributed vs. centralized
> > workflow in terms of kernel projects, lets please at least compare
> > apples to apples here.
> >
> > Best,
> >
> > --nab
> 
> I've been trying to keep my 2 cents out of this, as I am merely an
> SCST user.  Both of you have valid criticisms; the choice of SCM is
> not one of them.  It is nit-picking at best, especially when SCST
> could switch to git easily if they so desired.
> 
> Seven years ago, would you be pushing BitKeeper?
> 

Hi Mark,

I will always be advocating using the best tool for the job in any given
situation.  So absoulutely, I would have picked bitkeeper over tarballs
any day of the week 7 years ago, or over SVN if it had existed back
then.

But again, I think it's an important point that git is a tool that was
made explictly for the linux kernel workflow.  Why would a new subsystem
maintainer is participates in the kernel workflow ever use anything
besides git at this point..?

And sorry, but considering the obvious advantages in terms of workflow
speed and flexibility that git brings to the table for a subsystem
maintainer, calling the choise of SCM a nit-pick item demonstrates a
level certain level of inexperience wrt to mainline kernel workflow.
Which is perfectly OK, but if you really want to understand the issues
at hand in a distributed vs. centrailized SCM model, I strongly suggest
you watch Linus's talk as well.

Best,

--nab


