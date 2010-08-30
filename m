Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754775Ab0H3Ikz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Aug 2010 04:40:55 -0400
Received: from miranda.se.axis.com ([193.13.178.8]:49095 "EHLO
	miranda.se.axis.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751662Ab0H3Iky convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Aug 2010 04:40:54 -0400
From: Mikael Starvik <mikael.starvik@axis.com>
To: Claudio Scordino <claudio@evidence.eu.com>,
        Jesper Nilsson <Jesper.Nilsson@axis.com>
CC: linux-cris-kernel <linux-cris-kernel@axis.com>,
        Alan Cox <alan@lxorguk.ukuu.org.uk>,
        Andrew Morton <akpm@linux-foundation.org>,
        Hinko Kocevar <hinko.kocevar@cetrtapot.si>,
        Janez Cufer <janez.cufer@cetrtapot.si>,
        Andy Whitcroft <apw@canonical.com>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        dev-etrax <dev-etrax@axis.com>,
        "linux-serial@vger.kernel.org" <linux-serial@vger.kernel.org>
Date: Mon, 30 Aug 2010 10:39:54 +0200
Subject: RE: [PATCH] CRIS RS485: Check SER_RS485_RTS_BEFORE_SEND before
 delaying.
Thread-Topic: [PATCH] CRIS RS485: Check SER_RS485_RTS_BEFORE_SEND before
 delaying.
Thread-Index: ActIHqnbdgLmzJXjR9G6q9ZskdDTTAAACpCw
Message-ID: <4BEA3FF3CAA35E408EA55C7BE2E61D05583CAE6AF5@xmail3.se.axis.com>
References: <4C62BD2B.2010508@evidence.eu.com>
 <4C7B6C9B.2050801@evidence.eu.com>
In-Reply-To: <4C7B6C9B.2050801@evidence.eu.com>
Accept-Language: sv-SE
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: sv-SE
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

Jesper is on vacation but I find this patch ok.

Acked-by: Mikael Starvik<Starvik@axis.com>

/Mikael

-----Original Message-----
From: Claudio Scordino [mailto:claudio@evidence.eu.com] 
Sent: den 30 augusti 2010 10:32
To: Jesper Nilsson
Cc: Mikael Starvik; linux-cris-kernel; Alan Cox; Andrew Morton; Hinko Kocevar; Janez Cufer; Andy Whitcroft; Linux Kernel; dev-etrax; linux-serial@vger.kernel.org
Subject: Re: [PATCH] CRIS RS485: Check SER_RS485_RTS_BEFORE_SEND before delaying.

Claudio Scordino ha scritto:
> Hi Jesper,
> 
> 	the following patch fixes the usage of the delay in RS485 mode
> on the Cris architecture.
> 
> Very recently, the RS485 interface has been fixed by adding two further
> fields (see commit 1b6331848b69d1ed165a6bdc75c4046d68767563).
> 
> This patch checks the value of the flag SER_RS485_RTS_BEFORE_SEND before
> delaying.


Hi all,

	so far I didn't receive any acknowledgement about this patch.

As I said, recently (see commit 1b6331848b69d1ed165a6bdc75c4046d68767563) the
Linux RS485 interface has been fixed by adding two missing fields.

With the "new" interface, you have to check the SER_RS485_RTS_BEFORE_SEND flag
before using the delay_rts_before_send field.

The Atmel serial driver has been already fixed (with commit
1b6331848b69d1ed165a6bdc75c4046d68767563 itself).

This patch fixes the usage of the interface in the Cris driver too.

Best regards,

		Claudio
