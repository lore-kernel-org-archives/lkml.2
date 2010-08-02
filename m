Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753198Ab0HBNf4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Aug 2010 09:35:56 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:56131 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751879Ab0HBNfz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Aug 2010 09:35:55 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: "Justin P. Mattock" <justinmattock@gmail.com>
Subject: Re: [Bug #16337] general protection fault: 0000 [#1] SMP
Date: Mon, 2 Aug 2010 15:34:51 +0200
User-Agent: KMail/1.13.5 (Linux/2.6.35-rjw+; KDE/4.4.4; x86_64; ; )
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Kernel Testers List <kernel-testers@vger.kernel.org>,
        Maciej Rutecki <maciej.rutecki@gmail.com>,
        Pauli Nieminen <suokkos@gmail.com>
References: <2dWFdr9kTFM.A.P0D.spXVMB@chimera> <Aan7wZ97YaE.A.TCF.1qXVMB@chimera> <4C5618DA.1020407@gmail.com>
In-Reply-To: <4C5618DA.1020407@gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201008021534.52133.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, August 02, 2010, Justin P. Mattock wrote:
> On 08/01/2010 06:52 AM, Rafael J. Wysocki wrote:
> > This message has been generated automatically as a part of a summary report
> > of recent regressions.
> >
> > The following bug entry is on the current list of known regressions
> > from 2.6.34.  Please verify if it still should be listed and let the tracking team
> > know (either way).
> >
> >
> > Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=16337
> > Subject		: general protection fault: 0000 [#1] SMP
> > Submitter	: Justin P. Mattock<justinmattock@gmail.com>
> > Date		: 2010-07-03 22:59 (30 days old)
> > Message-ID	:<4C2FC0E3.6050101@gmail.com>
> > References	: http://marc.info/?l=linux-kernel&m=127819798215589&w=2
> >
> >
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> > Please read the FAQ at  http://www.tux.org/lkml/
> >
> 
> Ive played around with the machine that originally hit this. but still 
> cant seem to reproduce or trigger this.

I'll close it, then.  Please reopen if you reproduce the issue.

Rafael
