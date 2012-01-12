Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752800Ab2ALKld (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jan 2012 05:41:33 -0500
Received: from eu1sys200aog117.obsmtp.com ([207.126.144.143]:50226 "EHLO
	eu1sys200aog117.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751153Ab2ALKla convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jan 2012 05:41:30 -0500
From: Rajanikanth H V <rajanikanth.hv@stericsson.com>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: "linux-serial@vger.kernel.org" <linux-serial@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "gregkh@sude.de" <gregkh@sude.de>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Rajanikanth H V <rajanikanth.hv@stericsson.com>
Date: Thu, 12 Jan 2012 10:49:38 +0100
Subject: RE: tty/serial: Need clarification on Support for 4+M Baudrate
Thread-Topic: tty/serial: Need clarification on Support for 4+M Baudrate
Thread-Index: AczQXLVV+HEnQgmLQAycVGlH8YtLXQAsjquQ
Message-ID: <2B1D156D95AE9B4EAD379CB9E465FE7324AF2A605A@EXDCVYMBSTM005.EQ1STM.local>
References: <20120111121901.GA4034@bnru05>
 <20120111123025.244a9cf5@pyramind.ukuu.org.uk>
In-Reply-To: <20120111123025.244a9cf5@pyramind.ukuu.org.uk>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alan,

Thanks for your response, suggested modification helped to get 4.8M baud
but not 4.05M as this is being approximated to 4.0M baud which happens in
tty_termios_encode_baud_rate(...).

I have precise and weird requirement to get 4.05M baud as uart
baud clock divisor value changes between 4.0M and 4.05M Baud.

Any suggestion?

Thanks,
Rajanikanth

-----Original Message-----
From: Alan Cox [mailto:alan@lxorguk.ukuu.org.uk] 
Sent: Wednesday, January 11, 2012 6:00 PM
To: Rajanikanth H V
Cc: linux-serial@vger.kernel.org; linux-kernel@vger.kernel.org; gregkh@sude.de; linux-arm-kernel@lists.infradead.org
Subject: Re: tty/serial: Need clarification on Support for 4+M Baudrate

On Wed, 11 Jan 2012 17:49:01 +0530
> I have a requirement to interface UART with an external microcontroller 
> using baud rate above 4Mbps, hence following is my approach to apply
> the changes. Can any one review/provide me appropriate approach.

See TCGETS2/TCSETS2 and the BOTHER flag.

The kernel supports aetting arbitary baud rates already.

Alan
