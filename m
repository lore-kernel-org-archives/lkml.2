Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754330Ab0HJTsY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Aug 2010 15:48:24 -0400
Received: from be1ssnxpe2.nxp.com ([57.67.164.70]:50811 "EHLO
	be1ssnxpe2.nxp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750760Ab0HJTsV convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Aug 2010 15:48:21 -0400
From: Kevin Wells <kevin.wells@nxp.com>
To: Alessandro Zummo <a.zummo@towertech.it>,
        "rtc-linux@googlegroups.com" <rtc-linux@googlegroups.com>
CC: Durgesh Pattamatta <durgesh.pattamatta@nxp.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "wellsk40@gmail.com" <wellsk40@gmail.com>
Date: Tue, 10 Aug 2010 21:08:18 +0200
Subject: RE: [rtc-linux] [PATCH 1/2] rtc: rtc-lpc32xx: Introduce RTC driver
	for  the LPC32XX SoC
Thread-Topic: [rtc-linux] [PATCH 1/2] rtc: rtc-lpc32xx: Introduce RTC driver
	for  the LPC32XX SoC
Thread-Index: Acs4kkuA4ysKyragS6Ou4fBMqN3KEAAI9CJQ
Message-ID: <083DF309106F364B939360100EC290F80AC6E5F76E@eu1rdcrdc1wx030.exi.nxp.com>
References: <1281370650-29520-1-git-send-email-wellsk40@gmail.com>
	<1281370650-29520-2-git-send-email-wellsk40@gmail.com>
 <20100810153448.17443314@linux.lan.towertech.it>
In-Reply-To: <20100810153448.17443314@linux.lan.towertech.it>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10432:5.0.10011,1.0.148,0.0.0000 definitions=2010-08-10_07:2010-08-10,2010-08-10,1970-01-01 signatures=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Alessandro,

Thanks for helping to review this.

> 
> > +
> > +	retval = request_irq(rtc->irq, lpc32xx_rtc_alarm_interrupt,
> > +		IRQF_DISABLED, "rtcalarm", rtc);
> > +	if (retval < 0) {
> > +		dev_err(&pdev->dev, "Can't request interrupt\n");
> > +		goto err_free_irq;
> > +	}
> 
>  if the driver can work without the alarm irq you
>  can convert this to a non fatal warning.
> 
>  having an rtc without alarms is much better than having none.
> 

Good suggestion. I'll change this.

> --
> 
>  Best regards,
> 
>  Alessandro Zummo,
>   Tower Technologies - Torino, Italy
> 
>   http://www.towertech.it
> 

