Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760918Ab0HLVyZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Aug 2010 17:54:25 -0400
Received: from be1ssnxpe2.nxp.com ([57.67.164.70]:43251 "EHLO
	be1ssnxpe2.nxp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760829Ab0HLVyY convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Aug 2010 17:54:24 -0400
From: Kevin Wells <kevin.wells@nxp.com>
To: Wolfram Sang <w.sang@pengutronix.de>,
        "rtc-linux@googlegroups.com" <rtc-linux@googlegroups.com>
CC: Durgesh Pattamatta <durgesh.pattamatta@nxp.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Kevin Wells <wellsk40@gmail.com>
Date: Thu, 12 Aug 2010 23:54:02 +0200
Subject: RE: [rtc-linux] [PATCH] rtc: rtc-lpc32xx: Introduce RTC driver for
	the LPC32XX SoC (v2)
Thread-Topic: [rtc-linux] [PATCH] rtc: rtc-lpc32xx: Introduce RTC driver for
	the LPC32XX SoC (v2)
Thread-Index: Acs5/tyHqV8iJc9tSfmC04TfTKQyvgAaYl9Q
Message-ID: <083DF309106F364B939360100EC290F80AC719C808@eu1rdcrdc1wx030.exi.nxp.com>
References: <1281567980-12792-1-git-send-email-wellsk40@gmail.com>
	<1281567980-12792-2-git-send-email-wellsk40@gmail.com>
 <20100812090727.GA6787@pengutronix.de>
In-Reply-To: <20100812090727.GA6787@pengutronix.de>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10432:5.0.10011,1.0.148,0.0.0000 definitions=2010-08-12_10:2010-08-12,2010-08-12,1970-01-01 signatures=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > +
> > +/*
> > + * Clock and Power control register offsets  */
> > +#define RTC_UCOUNT		0x00
> > +#define RTC_DCOUNT		0x04
> > +#define RTC_MATCH0		0x08
> > +#define RTC_MATCH1		0x0C
> > +#define RTC_CTRL		0x10
> > +#define RTC_INTSTAT		0x14
> > +#define RTC_KEY			0x18
> > +#define RTC_SRAM		0x80
> 
> How about LPC32XX_-prefixes here?
> 

Hi Wolfram,

This and all following items are updated in v3

thanks,
Kevin

