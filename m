Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754262Ab1EALaT (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 May 2011 07:30:19 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:39864 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753626Ab1EALaQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 May 2011 07:30:16 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: "Justin P. Mattock" <justinmattock@gmail.com>
Subject: Re: [Bug #30582] WARNING: at drivers/net/wireless/ath/ath9k/recv.c:536 ath_stoprecv+0xc8/0xda [ath9k]()
Date: Sun, 1 May 2011 13:27:27 +0200
User-Agent: KMail/1.13.6 (Linux/2.6.39-rc5+; KDE/4.6.0; x86_64; ; )
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Kernel Testers List <kernel-testers@vger.kernel.org>,
        Maciej Rutecki <maciej.rutecki@gmail.com>,
        Florian Mickler <florian@mickler.org>
References: <QbBtx5c9v1J.A.JaF.PxGvNB@chimera> <9nxEC7x0HFO.A.z1G.0yGvNB@chimera> <4DBC8F30.4000301@gmail.com>
In-Reply-To: <4DBC8F30.4000301@gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201105011327.27720.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday, May 01, 2011, Justin P. Mattock wrote:
> On 04/30/2011 01:17 PM, Rafael J. Wysocki wrote:
> > This message has been generated automatically as a part of a report
> > of regressions introduced between 2.6.37 and 2.6.38.
> >
> > The following bug entry is on the current list of known regressions
> > introduced between 2.6.37 and 2.6.38.  Please verify if it still should
> > be listed and let the tracking team know (either way).
> >
> >
> > Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=30582
> > Subject		: WARNING: at drivers/net/wireless/ath/ath9k/recv.c:536 ath_stoprecv+0xc8/0xda [ath9k]()
> > Submitter	: Justin Mattock<justinmattock@gmail.com>
> > Date		: 2011-03-03 5:47 (59 days old)
> > Message-ID	:<AANLkTik9To0Rkq2FRqQFB2wNu0kyJ7CzyBek2jBp36Cb@mail.gmail.com>
> > References	: http://marc.info/?l=linux-kernel&m=129913127722786&w=2
> >
> >
> >
> 
> appologizes for not responding last week on this. Anyways I looked at 
> the machine with the latest, and this is fixed over here(attached dmesg 
> to the bug report)

Closed.

Thanks,
Rafael
