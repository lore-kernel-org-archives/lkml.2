Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755998Ab1GJMYv (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Jul 2011 08:24:51 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:42876 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754550Ab1GJMYu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Jul 2011 08:24:50 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Pekka Enberg <penberg@kernel.org>
Subject: Re: [Bug #34942] [Bug] Kdump does not work when panic triggered due to MCE
Date: Sun, 10 Jul 2011 14:25:38 +0200
User-Agent: KMail/1.13.6 (Linux/3.0.0-rc6+; KDE/4.6.0; x86_64; ; )
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Kernel Testers List <kernel-testers@vger.kernel.org>,
        Maciej Rutecki <maciej.rutecki@gmail.com>,
        Florian Mickler <florian@mickler.org>,
        "K.Prasad" <prasad@linux.vnet.ibm.com>, borislav.petkov@amd.com,
        Ingo Molnar <mingo@elte.hu>
References: <AtAvQwe5sAK.A.loH.OlYGOB@chimera> <gK_efVqs2fP.A.k7.hnYGOB@chimera> <CAOJsxLE9UBoMocTaWAt7DSoFFwGP5oD901XyeK6jGHEzUuSjDg@mail.gmail.com>
In-Reply-To: <CAOJsxLE9UBoMocTaWAt7DSoFFwGP5oD901XyeK6jGHEzUuSjDg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201107101425.39218.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday, July 10, 2011, Pekka Enberg wrote:
> On Sun, Jul 10, 2011 at 1:58 PM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
> > This message has been generated automatically as a part of a report
> > of regressions introduced between 2.6.38 and 2.6.39.
> >
> > The following bug entry is on the current list of known regressions
> > introduced between 2.6.38 and 2.6.39.  Please verify if it still should
> > be listed and let the tracking team know (either way).
> >
> >
> > Bug-Entry       : http://bugzilla.kernel.org/show_bug.cgi?id=34942
> > Subject         : [Bug] Kdump does not work when panic triggered due to MCE
> > Submitter       : K.Prasad <prasad@linux.vnet.ibm.com>
> > Date            : 2011-05-06 16:54 (66 days old)
> > Message-ID      : <20110506165412.GB2719@in.ibm.com>
> > References      : http://marc.info/?l=linux-kernel&m=130470087226270&w=2
> 
> There's actually no mention that kdump worked with MCE in 2.6.38
> either. So is this really a regression?

Well, for us it's easier to assume a regression and drop it from the list
when it turns out not to be one.  I guess that's happend this time, so
the submitter is kindly asked to speak. :-)

Thanks,
Rafael
