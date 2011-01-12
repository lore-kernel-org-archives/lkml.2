Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756433Ab1ALAwB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Jan 2011 19:52:01 -0500
Received: from mms3.broadcom.com ([216.31.210.19]:4812 "EHLO MMS3.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756359Ab1ALAwA convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Jan 2011 19:52:00 -0500
X-Server-Uuid: B55A25B1-5D7D-41F8-BC53-C57E7AD3C201
From: "Jian Peng" <jipeng@broadcom.com>
To: Harik <harik.attar@gmail.com>
cc: "Tejun Heo" <tj@kernel.org>, "Robert Hancock" <hancockrwd@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "jgarzik@pobox.com" <jgarzik@pobox.com>,
        ide <linux-ide@vger.kernel.org>
Date: Tue, 11 Jan 2011 16:51:46 -0800
Subject: RE: questions regarding possible violation of AHCI spec in AHCI
 driver
Thread-Topic: questions regarding possible violation of AHCI spec in
 AHCI driver
Thread-Index: Acux8jsJYrRtF5txQi2YnjvBxplanQAAKI6Q
Message-ID: <E18F441196CA634DB8E1F1C56A50A874319FE61FEE@IRVEXCHCCR01.corp.ad.broadcom.com>
References: <4CFF58D2.4040006@kernel.org>
 <E18F441196CA634DB8E1F1C56A50A874319FA38C43@IRVEXCHCCR01.corp.ad.broadcom.com>
 <4CFFCD56.6050608@kernel.org>
 <E18F441196CA634DB8E1F1C56A50A874319FA7E36E@IRVEXCHCCR01.corp.ad.broadcom.com>
 <4CFFD3EB.10800@kernel.org>
 <E18F441196CA634DB8E1F1C56A50A874319FA7E36F@IRVEXCHCCR01.corp.ad.broadcom.com>
 <4CFFE29C.7080205@kernel.org>
 <E18F441196CA634DB8E1F1C56A50A874319FA38CD3@IRVEXCHCCR01.corp.ad.broadcom.com>
 <4D000C8B.5040904@kernel.org>
 <E18F441196CA634DB8E1F1C56A50A874319FD72B23@IRVEXCHCCR01.corp.ad.broadcom.com>
 <20110111182323.GG15933@htj.dyndns.org>
 <E18F441196CA634DB8E1F1C56A50A874319FA7E37B@IRVEXCHCCR01.corp.ad.broadcom.com>
 <AANLkTinpWS4yzAoHE5nTPtQ3OAU1SvM1mN2tMjsur8BW@mail.gmail.com>
In-Reply-To: <AANLkTinpWS4yzAoHE5nTPtQ3OAU1SvM1mN2tMjsur8BW@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
MIME-Version: 1.0
X-WSS-ID: 613224E51VG4376708-01-01
Content-Type: text/plain;
 charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Unfortunately, no

-----Original Message-----
From: Harik [mailto:harik.attar@gmail.com] 
Sent: Tuesday, January 11, 2011 4:46 PM
To: Jian Peng
Cc: Tejun Heo; Robert Hancock; linux-kernel@vger.kernel.org; jgarzik@pobox.com; ide
Subject: Re: questions regarding possible violation of AHCI spec in AHCI driver

> +           (tmp & 0x0f) != 0x03) {
> +               printk(KERN_DEBUG "START bit was not set in %s\n", __func__);
> +               return;
> +       }

Are there defines for the mask and result that you could use instead of raw hex?


