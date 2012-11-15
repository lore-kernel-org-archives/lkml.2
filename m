Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2992743Ab2KOHWg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Nov 2012 02:22:36 -0500
Received: from mms3.broadcom.com ([216.31.210.19]:2349 "EHLO mms3.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S2992535Ab2KOHWf convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Nov 2012 02:22:35 -0500
X-Server-Uuid: B86B6450-0931-4310-942E-F00ED04CA7AF
From: "Nithin Sujir" <nsujir@broadcom.com>
To: "David Rientjes" <rientjes@google.com>,
        "Paul Gortmaker" <paul.gortmaker@windriver.com>
cc: "Denys Fedoryshchenko" <denys@visp.net.lb>,
        "Michael Chan" <mchan@broadcom.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: Latest 3.6.6 are not compiling due tg3 network driver,
 hwmon_device_unregister
Thread-Topic: Latest 3.6.6 are not compiling due tg3 network driver,
 hwmon_device_unregister
Thread-Index: AQHNwt3hc4qW3XbI0Ue7QnvCHmJqRJfqO7WAgACHywD//7nloA==
Date: Thu, 15 Nov 2012 07:22:20 +0000
Message-ID: <DAAFBCC105999F468732FA900576CB4510069F69@IRVEXCHMB08.corp.ad.broadcom.com>
References: <8b566c4a9ee622737212dc17291ee238@visp.net.lb>
 <50A4606D.4020402@broadcom.com>
 <alpine.DEB.2.00.1211141929510.14414@chino.kir.corp.google.com>
In-Reply-To: <alpine.DEB.2.00.1211141929510.14414@chino.kir.corp.google.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.9.208.64]
MIME-Version: 1.0
X-WSS-ID: 7CBA48B23P83129761-01-01
Content-Type: text/plain;
 charset=us-ascii
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



> -----Original Message-----
> From: David Rientjes [mailto:rientjes@google.com]
> Sent: Wednesday, November 14, 2012 7:31 PM
> To: Nithin Sujir; Paul Gortmaker
> Cc: Denys Fedoryshchenko; Michael Chan; netdev@vger.kernel.org; linux-
> kernel@vger.kernel.org
> Subject: Re: Latest 3.6.6 are not compiling due tg3 network driver,
> hwmon_device_unregister
> 
> On Wed, 14 Nov 2012, Nithin Nayak Sujir wrote:
> 
> > This was fixed by
> >
> > commit de0a41484c47d783dd4d442914815076aa2caac2
> > Author: Paul Gortmaker <paul.gortmaker@windriver.com>
> > Date:   Mon Oct 1 11:43:49 2012 -0400
> >
> >     tg3: unconditionally select HWMON support when tg3 is enabled.
> >
> 
> Would you mind submitting this for stable by following the procedure
> described in Documentation/stable_kernel_rules.txt?


Seems to have been taken into stable already. 
http://git.kernel.org/?p=linux/kernel/git/stable/linux-stable.git;a=commitdiff;h=aecdc33e111b2c447b622e287c6003726daa1426

Nithin.



