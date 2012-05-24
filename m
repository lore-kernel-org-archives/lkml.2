Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755662Ab2EXKTO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 May 2012 06:19:14 -0400
Received: from va3ehsobe003.messaging.microsoft.com ([216.32.180.13]:53273
	"EHLO va3outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755246Ab2EXKTK convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 May 2012 06:19:10 -0400
X-Forefront-Antispam-Report: CIP:59.163.77.45;KIP:(null);UIP:(null);IPV:NLI;H:KCHJEXHC01.kpit.com;RD:59.163.77.45.static.vsnl.net.in;EFVD:NLI
X-SpamScore: -14
X-BigFish: VPS-14(zz9371I1be0I1102I542M1432Nzz1202hzz8275bhz2dh2a8h668h839h944hd25hf0ah)
From: Ashish Jangam <Ashish.Jangam@kpitcummins.com>
To: Wim Van Sebroeck <wim@iguana.be>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-watchdog@vger.kernel.org" <linux-watchdog@vger.kernel.org>,
        Anthony Olech <Anthony.Olech@diasemi.com>,
        "sameo@linux.intel.com" <sameo@linux.intel.com>
Subject: RE: [PATCH] Watchdog: Fix for settimeout issue
Thread-Topic: [PATCH] Watchdog: Fix for settimeout issue
Thread-Index: AQHNORLX2VYWsaLJqk2qZLD4N46J45bYuoAg
Date: Thu, 24 May 2012 10:19:04 +0000
Message-ID: <C3AE124F08223B42BC95AEB82F0F6CED30402926@KCHJEXMB02.kpit.com>
References: <1335768031.9546.20.camel@dhruva>
 <20120523183623.GN3074@spo001.leaseweb.com>
In-Reply-To: <20120523183623.GN3074@spo001.leaseweb.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [94.185.165.50]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OriginatorOrg: kpitcummins.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> -----Original Message-----
> From: wimvs@spo001.leaseweb.com [mailto:wimvs@spo001.leaseweb.com] On
> Behalf Of Wim Van Sebroeck
> Sent: Thursday, May 24, 2012 12:06 AM
> To: Ashish Jangam
> Cc: linux-kernel@vger.kernel.org; linux-watchdog@vger.kernel.org; Anthony
> Olech; sameo@linux.intel.com
> Subject: Re: [PATCH] Watchdog: Fix for settimeout issue
> 
> Hi Ashish,
> 
> > Some devices have a fixed minimum elapse time and a ping before this
> > elapse time causes error condition. This patch fix this issue in the
> > settimeout operation.
> 
> Won't add this patch. The driver needs to take care of the mdelay.
> PS: for da9052_wdt: start (=set_timeout) + ping will also give you
> the same problem.

Ok, re-sending the patch with this fix....Ashish
> 
> Kind regards,
> Wim.
> 

