Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754295Ab0F0Cnm (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Jun 2010 22:43:42 -0400
Received: from n17.bullet.mail.mud.yahoo.com ([68.142.206.144]:20905 "HELO
	n17.bullet.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1754092Ab0F0Cnk convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Jun 2010 22:43:40 -0400
X-Yahoo-Newman-Property: ymail-3
X-Yahoo-Newman-Id: 454460.44773.bm@omp122.mail.gq1.yahoo.com
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Message-ID:X-YMail-OSG:Received:X-Mailer:Date:From:Subject:To:Cc:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding;
  b=EQ24Ozx6mbhAdu+9H+Eeii8/8vk4IbEhtZ6vEdiC0YiYH6Oub255iik7ZJkig58WevvvzESF9wAAwi1TA/nELsQv4y8M4BlTxlUmbOZnPBkzMoraFW2eYvOI2crgAmdd3jZS+ewWV4Pljob09iyxJ0NPQF0ETC5dZuCSPvpoeQc=;
Message-ID: <323677.5124.qm@web180313.mail.gq1.yahoo.com>
X-YMail-OSG: MetlwO8VM1lOWhh8xhyFIN9XJpiKdUPyQr732EhcH_9BqrV
 .M7ZzeN6AD6irEZcAhtg1_NbCGFHWdtetrx0NHDhzutgYDEMp.GCbbEQuqgn
 N9Hm_xSb1ZJISVZTvNp7dr0gRKZJrbe2M9wzKjKgyNB6njvI8d1X6Jvx33QT
 vZTDQ4e0m60ayXadXoIMf56uFvzXJkApLAkGz6CUC4eRRmGl.3oIUb0vyzT.
 8o4dbL0MNK4_SEbXCgz7BoXjW4bqWVd0MeCnbfeaEA3aKwGwoMWh3tB68qGn
 ZZx45PqHf95EzPLdc_FpMe_ZouDQrIw--
X-Mailer: YahooMailClassic/11.1.4 YahooMailWebService/0.8.104.274457
Date: Sat, 26 Jun 2010 19:43:39 -0700 (PDT)
From: David Brownell <david-b@pacbell.net>
Subject: Re: [linux-pm] [PATCH] PM: Make it possible to avoid wakeup events from being lost
To: Alan Stern <stern@rowland.harvard.edu>
Cc: linux-pm@lists.linux-foundation.org, "Rafael J. Wysocki" <rjw@sisk.pl>,
       mark gross <640e9920@gmail.com>, Florian Mickler <florian@mickler.org>,
       Neil Brown <neilb@suse.de>, linux-pci@vger.kernel.org,
       Dmitry Torokhov <dmitry.torokhov@gmail.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Jesse Barnes <jbarnes@virtuousgeek.org>,
       Arve@smtp1.linux-foundation.org
In-Reply-To: <Pine.LNX.4.44L0.1006261258140.22018-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> > This is a repeat of an issue I posted before, but
> > which for some reason I never saw email back ...
> 
> I replied to one of your emails on this topic.  Maybe you didn't see the reply.

I guess not; I'll see if there's some message
buried in a too-much-email folder.)
> 
> > basically, I think the notion of counting wakeup
> > events seems dubious on common hardware, ...
> I disagree. 
> 
> The "counting" isn't meant as a way of keeping track of the absolute
> number of these events.  It's more like a technique  for seeing how many
> remain outstanding at any time.

But if you can't count them with any
reliability, you can't know *that* either... so
there must be a a problem with that model.


