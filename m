Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756462Ab2BXJOK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Feb 2012 04:14:10 -0500
Received: from mail-tul01m020-f174.google.com ([209.85.214.174]:44475 "EHLO
	mail-tul01m020-f174.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756286Ab2BXJOH convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Feb 2012 04:14:07 -0500
MIME-Version: 1.0
In-Reply-To: <qCQH7HfZS8E.A.UOG.H9rRPB@chimera>
References: <y44pDJ8xoDC.A.08E.h8rRPB@chimera>
	<qCQH7HfZS8E.A.UOG.H9rRPB@chimera>
Date: Fri, 24 Feb 2012 10:14:05 +0100
Message-ID: <CAPVoSvQqtLmH3rnmGQqOM9V2g4_VDbGtOWfvf2Ag09zxX=8HqA@mail.gmail.com>
Subject: Re: [Bug #42678] [3.3-rc1] radeon stuck in kernel after lockup
From: Torsten Kaiser <just.for.lkml@googlemail.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Kernel Testers List <kernel-testers@vger.kernel.org>,
        Maciej Rutecki <maciej.rutecki@gmail.com>,
        Florian Mickler <florian@mickler.org>,
        =?ISO-8859-1?Q?J=E9r=F4me_Glisse?= <glisse@freedesktop.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2012/2/23 Rafael J. Wysocki <rjw@sisk.pl>:
> This message has been generated automatically as a part of a summary report
> of recent regressions.
>
> The following bug entry is on the current list of known regressions
> from 3.2.  Please verify if it still should be listed and let the tracking team
> know (either way).
>
>
> Bug-Entry       : http://bugzilla.kernel.org/show_bug.cgi?id=42678
> Subject         : [3.3-rc1] radeon stuck in kernel after lockup
> Submitter       : Torsten Kaiser <just.for.lkml@googlemail.com>
> Date            : 2012-01-21 19:03 (34 days old)
> Message-ID      : <CAPVoSvSXMvRb=1itu9DjF+s=6zfAChvUxS-x=b8EV9kOZinNpA@mail.gmail.com>
> References      : http://marc.info/?l=linux-kernel&m=132717279606670&w=2
> Handled-By      : Jérôme Glisse <glisse@freedesktop.org>

As requested: Yes, I think it is still open and should be listed as an
regression.

I put a summary about why I think this way into the Bugzilla bug. I
believe putting this into Bugzilla was the better way, as to not lose
it on the lkml. But I will also try to answer email, if that is
preferred.

Torsten
