Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755287Ab2BYVBN (ORCPT <rfc822;w@1wt.eu>);
	Sat, 25 Feb 2012 16:01:13 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:42267 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753023Ab2BYVBL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 25 Feb 2012 16:01:11 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Bret Towe <magnade@gmail.com>, Mark Fasheh <mfasheh@suse.com>,
        Joel Becker <jlbec@evilplan.org>
Subject: Re: [Bug #42571] BUG in ofcs2_change_file_space
Date: Sat, 25 Feb 2012 22:05:11 +0100
User-Agent: KMail/1.13.6 (Linux/3.3.0-rc4+; KDE/4.6.0; x86_64; ; )
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Kernel Testers List <kernel-testers@vger.kernel.org>,
        Maciej Rutecki <maciej.rutecki@gmail.com>,
        Florian Mickler <florian@mickler.org>
References: <1qKPXd1RqtP.A.wjG.ShsRPB@chimera> <JM4ZOHxb-FL.A.TVH.rhsRPB@chimera> <CALjC5haUKCnSmjjdXX7WwV7idOHueWTQE2yFnOSmJ4JFQmWjfg@mail.gmail.com>
In-Reply-To: <CALjC5haUKCnSmjjdXX7WwV7idOHueWTQE2yFnOSmJ4JFQmWjfg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-2"
Content-Transfer-Encoding: 7bit
Message-Id: <201202252205.11779.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday, February 25, 2012, Bret Towe wrote:
> the patch is still working great and I still see no evidence of it being in
> mainline

Thanks for the update.

> On Thu, Feb 23, 2012 at 3:05 PM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
> 
> > This message has been generated automatically as a part of a report
> > of regressions introduced between 3.1 and 3.2.
> >
> > The following bug entry is on the current list of known regressions
> > introduced between 3.1 and 3.2.  Please verify if it still should
> > be listed and let the tracking team know (either way).
> >
> >
> > Bug-Entry       : http://bugzilla.kernel.org/show_bug.cgi?id=42571
> > Subject         : BUG in ofcs2_change_file_space
> > Submitter       : Bret Towe <magnade@gmail.com>
> > Date            : 2012-01-05 22:23 (50 days old)
> > Message-ID      : <
> > CALjC5haTNDMOTDPL1m1uBTc2a-Qb8cvR44SCaVDFMzGc+Gw3+w@mail.gmail.com>
> > References      : http://marc.info/?l=linux-kernel&m=132580236211209&w=2
> > Patch           :
> > http://oss.oracle.com/pipermail/ocfs2-devel/2012-January/008464.html

Mark, Joel, are there any plans to merge the above patch any time soon?

Rafael
