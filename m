Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755959Ab1GJUWx (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Jul 2011 16:22:53 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:43381 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754620Ab1GJUWt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Jul 2011 16:22:49 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Jeff Layton <jlayton@redhat.com>
Subject: Re: [Bug #36952] [2.6.39] CIFS write failures where 2.6.38 works
Date: Sun, 10 Jul 2011 22:23:56 +0200
User-Agent: KMail/1.13.6 (Linux/3.0.0-rc6+; KDE/4.6.0; x86_64; ; )
Cc: Pekka Enberg <penberg@kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Kernel Testers List <kernel-testers@vger.kernel.org>,
        Maciej Rutecki <maciej.rutecki@gmail.com>,
        Florian Mickler <florian@mickler.org>,
        Helge Hafting <helge.hafting@hist.no>
References: <AtAvQwe5sAK.A.loH.OlYGOB@chimera> <CAOJsxLHNKTh_ATo4_mQfjUfqtddheE-+bF14SPCNYBu+fjW9Tw@mail.gmail.com> <20110710143458.531f226d@tlielax.poochiereds.net>
In-Reply-To: <20110710143458.531f226d@tlielax.poochiereds.net>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201107102223.56834.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday, July 10, 2011, Jeff Layton wrote:
> On Sun, 10 Jul 2011 14:58:54 +0300
> Pekka Enberg <penberg@kernel.org> wrote:
> 
> > On Sun, Jul 10, 2011 at 1:58 PM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
> > > This message has been generated automatically as a part of a report
> > > of regressions introduced between 2.6.38 and 2.6.39.
> > >
> > > The following bug entry is on the current list of known regressions
> > > introduced between 2.6.38 and 2.6.39.  Please verify if it still should
> > > be listed and let the tracking team know (either way).
> > >
> > > Bug-Entry       : http://bugzilla.kernel.org/show_bug.cgi?id=36952
> > > Subject         : [2.6.39] CIFS write failures where 2.6.38 works
> > > Submitter       : Helge Hafting <helge.hafting@hist.no>
> > > Date            : 2011-06-01 10:11 (40 days old)
> > > Message-ID      : <4DE6103E.6010100@hist.no>
> > > References      : http://marc.info/?l=linux-kernel&m=130692387613423&w=2
> > 
> > The last comment in Bugzilla states that Jeff was working on a patch.
> > Was it ever submitted to mainline and stable?
> > 
> >                                 Pekka
> 
> Yes, see commit 1190f6a067b in mainline. I also backported it for
> 2.6.39-stable and sent it to stable@kernel.org, but I haven't heard
> anything back on it yet (I'll resend if I don't hear anything in the
> next day or two).

Thanks, I've closed the bug.

Rafael
