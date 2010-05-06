Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755741Ab0EFIhM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 May 2010 04:37:12 -0400
Received: from de01.mail.all-tld.net ([195.140.232.8]:64128 "EHLO
	de01.mail.all-tld.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751234Ab0EFIhJ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 May 2010 04:37:09 -0400
Date: Thu, 06 May 2010 10:36:58 +0200
From: Anders Larsen <al@alarsen.net>
Subject: Re: [at91] Save power by disabling the processor clock when CPU is
 idle
To: =?iso-8859-1?q?Uwe_Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>
Cc: Andrew Victor <avictor.za@gmail.com>, linux-kernel@vger.kernel.org,
       linux-arm-kernel@lists.infradead.org
In-Reply-To: <20100505202529.GB25037@pengutronix.de> (from
	u.kleine-koenig@pengutronix.de on Wed May  5 22:25:29 2010)
X-Mailer: Balsa 2.3.14
Message-Id: <1273135018l.10732l.0l@i-dmzi_al.realan.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
References: <20100505202529.GB25037@pengutronix.de>
X-ALL-TLD-GmbH-Information: AEV Virus and Spam Secure Mail System
X-ALL-TLD-GmbH-VirusScanner: Found to be clean
X-ALL-TLD-GmbH-SpamCheck: 
X-MailScanner-From: al@alarsen.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On 2010-05-05 22:25:29, Uwe Kleine-König wrote:
> There is a kernel parameter (IIRC "nohlt") that should take care of
> this?!

I hadn't noticed that one (it's operating several layers above the piece
of code I modified).

So it seems we could do way with the #else clause completely (requiring
the user to set 'nohlt' when debugging with JTAG)?

Cheers
Anders
-- 
happy 'ptxdist' user
