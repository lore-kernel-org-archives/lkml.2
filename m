Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752095Ab1H1UFI (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Aug 2011 16:05:08 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:43733 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751179Ab1H1UFF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Aug 2011 16:05:05 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Chris Ball <cjb@laptop.org>
Subject: Re: [Bug #38922] Lenovo T420 (Sandy Bridge) Crashes on SD Card gpt partition writing and io errors on insert
Date: Sun, 28 Aug 2011 22:06:53 +0200
User-Agent: KMail/1.13.6 (Linux/3.1.0-rc2+; KDE/4.6.0; x86_64; ; )
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Kernel Testers List <kernel-testers@vger.kernel.org>,
        Maciej Rutecki <maciej.rutecki@gmail.com>,
        Florian Mickler <florian@mickler.org>,
        "Andrei Warkentin" <andreiw@motorola.com>,
        "Peter Vollmer" <vollmerpeter@googlemail.com>
References: <Sm7qbRR0zn.A.yAG.LepWOB@chimera> <gUVi6eNP8RE.A.uJH.tfpWOB@chimera> <m2fwklxqjy.fsf@bob.laptop.org>
In-Reply-To: <m2fwklxqjy.fsf@bob.laptop.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-2"
Content-Transfer-Encoding: 7bit
Message-Id: <201108282206.53949.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday, August 28, 2011, Chris Ball wrote:
> Hi Rafael,
> 
> On Sun, Aug 28 2011, Rafael J. Wysocki wrote:
> > This message has been generated automatically as a part of a report
> > of regressions introduced between 2.6.39 and 3.0.
> >
> > The following bug entry is on the current list of known regressions
> > introduced between 2.6.39 and 3.0.  Please verify if it still should
> > be listed and let the tracking team know (either way).
> >
> >
> > Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=38922
> > Subject : Lenovo T420 (Sandy Bridge) Crashes on SD Card gpt partition
> > writing and io errors on insert
> > Submitter	: Peter Vollmer <vollmerpeter@googlemail.com>
> > Date		: 2011-07-07 17:33 (53 days old)
> > First-Bad-Commit:
> > http://git.kernel.org/linus/a3c7778f8153b9e4eceea6738973280b9e63c618
> 
> Yes, still present.

Thanks for the update.

Rafael
