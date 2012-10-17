Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757643Ab2JQSmO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Oct 2012 14:42:14 -0400
Received: from smarthost1.sentex.ca ([64.7.153.18]:29910 "EHLO
	smarthost1.sentex.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756533Ab2JQSmM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Oct 2012 14:42:12 -0400
X-Qmail-Scanner-Mail-From: mghias@connecttech.com via vmail1.sentex.ca
X-Qmail-Scanner: 1.25 (Clear:RC:1(127.0.0.1):. Processed in 0.053042 secs)
From: "Muhammad Ghias" <mghias@connecttech.com>
To: "'Marc Kleine-Budde'" <mkl@pengutronix.de>
Cc: "'Wolfgang Grandegger'" <wg@grandegger.com>,
        <linux-kernel@vger.kernel.org>, <linux-can@vger.kernel.org>
References: <02ac01cdabe1$b5403e10$1fc0ba30$@connecttech.com> <507E84C5.2040600@pengutronix.de>
In-Reply-To: <507E84C5.2040600@pengutronix.de>
Subject: RE: [PATCH] CAN: sja1000: Add support for Connect Tech Inc's Canpro/104-Plus Opto CAN board
Date: Wed, 17 Oct 2012 14:42:12 -0400
Organization: Connect Tech Inc.
Message-ID: <036301cdac97$1ee892d0$5cb9b870$@connecttech.com>
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
X-Mailer: Microsoft Outlook 14.0
Thread-Index: AQD9RveEPUHHP3XKLJ88t+1SPwN4QALa03EgmUfGIjA=
Content-Language: en-ca
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Marc,

I tested the patch v2 with kernel 3.6.1 and 3.7-rc1. Clean compile and works
with hardware.

Regards,
Muhammad

-----Original Message-----
From: Marc Kleine-Budde [mailto:mkl@pengutronix.de] 
Sent: October-17-12 6:13 AM
To: Muhammad Ghias
Cc: 'Wolfgang Grandegger'; linux-kernel@vger.kernel.org;
linux-can@vger.kernel.org
Subject: Re: [PATCH] CAN: sja1000: Add support for Connect Tech Inc's
Canpro/104-Plus Opto CAN board

On 10/16/2012 11:03 PM, Muhammad Ghias wrote:
> Patch adds support for CANpro/104-Plus Opto CAN board. Board uses PLX9030
> bridge and two NXP SJA1000 CAN controllers. Patch is generated and tested
> with kernel 3.6.1.
> 
> If you have any questions or any feedback please let me know.

Thanks, the code looks good. Please try, if possible, to send your
patches via git send-email, as outlooks messed up the patch. I've fixed
all line wrapping problems by hand, applied the patch and send a v2,
please test.

regards, Marc

P.S.: Please use the linux-can@vger.kernel.org mailing list for CAN
related patches/topics.

-- 
Pengutronix e.K.                  | Marc Kleine-Budde           |
Industrial Linux Solutions        | Phone: +49-231-2826-924     |
Vertretung West/Dortmund          | Fax:   +49-5121-206917-5555 |
Amtsgericht Hildesheim, HRA 2686  | http://www.pengutronix.de   |


