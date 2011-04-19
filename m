Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755000Ab1DSVsN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Apr 2011 17:48:13 -0400
Received: from mms3.broadcom.com ([216.31.210.19]:4846 "EHLO MMS3.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752018Ab1DSVsL convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Apr 2011 17:48:11 -0400
X-Server-Uuid: B55A25B1-5D7D-41F8-BC53-C57E7AD3C201
From: "Jian Peng" <jipeng@broadcom.com>
To: "Jeff Garzik" <jgarzik@pobox.com>
cc: "Tejun Heo" <tj@kernel.org>, "Robert Hancock" <hancockrwd@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        ide <linux-ide@vger.kernel.org>
Date: Tue, 19 Apr 2011 14:48:01 -0700
Subject: RE: questions regarding possible violation of AHCI spec in AHCI
 driver
Thread-Topic: questions regarding possible violation of AHCI spec in
 AHCI driver
Thread-Index: Acu3cw1ZQEatH4a4Tq+DzMhYSsstDxHaADWA
Message-ID: <E18F441196CA634DB8E1F1C56A50A8743242777421@IRVEXCHCCR01.corp.ad.broadcom.com>
References: <4CFF58D2.4040006@kernel.org>
 <E18F441196CA634DB8E1F1C56A50A874319FA38C43@IRVEXCHCCR01.corp.ad.broadcom.com>
 <4CFFCD56.6050608@kernel.org>
 <E18F441196CA634DB8E1F1C56A50A874319FA7E36E@IRVEXCHCCR01.corp.ad.broadcom.com>
 <4CFFD3EB.10800@kernel.org>
 <E18F441196CA634DB8E1F1C56A50A874319FA7E36F@IRVEXCHCCR01.corp.ad.broadcom.com>
 <4CFFE29C.7080205@kernel.org>
 <E18F441196CA634DB8E1F1C56A50A874319FA38CD3@IRVEXCHCCR01.corp.ad.broadcom.com>
 <4D000C8B.5040904@kernel.org>
 <E18F441196CA634DB8E1F1C56A50A874319FD72B23@IRVEXCHCCR01.corp.ad.broadcom.com>,<20110111182323.GG15933@htj.dyndns.org>
 <E18F441196CA634DB8E1F1C56A50A874319FA7E37B@IRVEXCHCCR01.corp.ad.broadcom.com>
 <4D36358E.40106@pobox.com>
In-Reply-To: <4D36358E.40106@pobox.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
MIME-Version: 1.0
X-WSS-ID: 61B0DC413I813881068-01-01
Content-Type: text/plain;
 charset=us-ascii
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, Jeff/Tejun,

I retested my patch using Marvell AHCI controller card and Intel built-in controller with 2.6.38 kernel, it worked well. I resubmitted the patch against Linus git tree in separate email through git send-email already. 

Please review it.

Thanks,
Jian

-----Original Message-----
From: Jeff Garzik [mailto:jgpobox@gmail.com] On Behalf Of Jeff Garzik
Sent: Tuesday, January 18, 2011 4:51 PM
To: Jian Peng
Cc: Tejun Heo; Robert Hancock; linux-kernel@vger.kernel.org; ide
Subject: Re: questions regarding possible violation of AHCI spec in AHCI driver

On 01/11/2011 01:55 PM, Jian Peng wrote:
> Here is new patch based on your suggestion (against 2.6.37 release)
[...]
> I will test host controller made by other vendors and report issues soon.

Any updates?

	Jeff





