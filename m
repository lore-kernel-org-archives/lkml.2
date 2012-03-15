Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755848Ab2COJmz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Mar 2012 05:42:55 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:37817 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752640Ab2COJmv convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Mar 2012 05:42:51 -0400
From: "Manjunathappa, Prakash" <prakash.pm@ti.com>
To: Sergei Shtylyov <sshtylyov@mvista.com>
CC: "davinci-linux-open-source@linux.davincidsp.com" 
	<davinci-linux-open-source@linux.davincidsp.com>,
        "linux@arm.linux.org.uk" <linux@arm.linux.org.uk>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "Gupta, Ajay Kumar" <ajay.gupta@ti.com>,
        "Nori, Sekhar" <nsekhar@ti.com>
Subject: RE: [PATCH] arm:da850: register musb device
Thread-Topic: [PATCH] arm:da850: register musb device
Thread-Index: AQHNAS0Ch7YKKgWwqkyyPVMdUjshLZZoGeKAgAE16cD///3igIABz4Kw
Date: Thu, 15 Mar 2012 09:42:20 +0000
Message-ID: <A73F36158E33644199EB82C5EC81C7BC31784B33@DBDE01.ent.ti.com>
References: <1331651015-32586-1-git-send-email-prakash.pm@ti.com>
 <4F5F7F91.8010301@mvista.com>
 <A73F36158E33644199EB82C5EC81C7BC3178406C@DBDE01.ent.ti.com>
 <4F6081C3.4070905@mvista.com>
In-Reply-To: <4F6081C3.4070905@mvista.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [172.24.162.24]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Sergei,

On Wed, Mar 14, 2012 at 17:02:19, Sergei Shtylyov wrote:
> Hello.
> 
> On 14-03-2012 10:16, Manjunathappa, Prakash wrote:
> 
> >>> Properly set up the OTG mode thru the CFGCHIP2 register, enable the
> >>> USB0_DRVVBUS pin,
> 
> >>      I don't see where you are enabling it.
> 
> > Yes, I will correct the message.
> 
> >>> and finally register the MUSB platform device.
> 
>     Also, you're registering the MUSB device for DA850/OMAP-L138 EVM board, 
> not the whole DA850/OMAP-L138 SoC, so that should be reflected in the subject.
> 

True, I will fix the subject.

Thanks,
Prakash

> >>> Signed-off-by: Ajay Kumar Gupta<ajay.gupta@ti.com>
> >>> Signed-off-by: Manjunathappa, Prakash<prakash.pm@ti.com>
> 
> WBR, Sergei
> 

