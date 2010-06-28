Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753414Ab0F1X2c (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jun 2010 19:28:32 -0400
Received: from n9.bullet.mail.ac4.yahoo.com ([76.13.13.237]:40716 "HELO
	n9.bullet.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752165Ab0F1X2b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jun 2010 19:28:31 -0400
X-Yahoo-Newman-Property: ymail-3
X-Yahoo-Newman-Id: 128519.36386.bm@omp124.mail.gq1.yahoo.com
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Message-ID:X-YMail-OSG:Received:X-Mailer:Date:From:Subject:To:Cc:In-Reply-To:MIME-Version:Content-Type;
  b=xyi9OWRd/+AHhJAV5560Rob6Z45z8Pq7OgFzkPDn0grjSKIKxHv1q7bg0AeSX8qcZCLKmUHd5REmiiccqMwkSzm2b+5zBAiYXhLsWs7pezqeBCicnE0H6RhNsmTJ9bt6C900M0Ao2wqUITvy5c0Tob1q7srVAeU0ro0PVzn9iE4=;
Message-ID: <53596.65110.qm@web180310.mail.gq1.yahoo.com>
X-YMail-OSG: hHk332IVM1mDrhzFBHXrhApSvfL5mHNMn8dMgeDupeywv6E
 fgt6QTqdZfDUXI06Rf_nEMpAVycsJvhuu_vliZFaQ7JU2DAS5FosXE1.Oakx
 xfEvErjclZrKMhni6kYLcFQSIY.LpHMxYJgjYJmdI1TdNx9o2bX83ZMMlTQi
 Yt.5.7wMLhzPUolFVF26hofcr9BzXzby0Eek9ztsO56OE6wNIkK7enwMv4GW
 cZxe5mXOnevimXIHXArHdr1Eo_pPIoMDsEnZ9ntDYP3JRKO3CF0_rBBBiHIZ
 DgahtFZaxlnfLPsy2cUI-
X-Mailer: YahooMailClassic/11.1.4 YahooMailWebService/0.8.104.274457
Date: Mon, 28 Jun 2010 16:28:29 -0700 (PDT)
From: David Brownell <david-b@pacbell.net>
Subject: Re: [linux-pm] [PATCH] PM: Make it possible to avoid wakeup events from being lost
To: Alan Stern <stern@rowland.harvard.edu>, "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: mark gross <640e9920@gmail.com>, Neil Brown <neilb@suse.de>,
       linux-pci@vger.kernel.org, Dmitry Torokhov <dmitry.torokhov@gmail.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Arve@smtp1.linux-foundation.org, Florian Mickler <florian@mickler.org>,
       Jesse Barnes <jbarnes@virtuousgeek.org>,
       linux-pm@lists.linux-foundation.org
In-Reply-To: <201006280159.10885.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Did someone post the canonical driver changes
to make use of this?  Something like

  suspend() { /* if wake-enabled, up count */ }
  resume() { /* if upcounted, downcount */ }

is what first comes to mind.. expecting that
the suspend/resume methods in the driver are
already doing the right things for enabling
and later disabling the "system wake" behavior
on the various relevant hardware events...



