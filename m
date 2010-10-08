Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759083Ab0JHRpb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Oct 2010 13:45:31 -0400
Received: from mms3.broadcom.com ([216.31.210.19]:1113 "EHLO MMS3.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758805Ab0JHRpa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Oct 2010 13:45:30 -0400
X-Server-Uuid: B55A25B1-5D7D-41F8-BC53-C57E7AD3C201
From: "Brett Rudley" <brudley@broadcom.com>
To: "Jon Masters" <jonathan@jonmasters.org>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
cc: "Henry Ptasinski" <henryp@broadcom.com>, "Nohee Ko" <noheek@broadcom.com>,
        "Jon Masters" <jcm@jonmasters.org>,
        LKML <linux-kernel@vger.kernel.org>
Date: Fri, 8 Oct 2010 10:45:14 -0700
Subject: RE: PROBLEM: brcm80211 hangs on
 2.6.36-0.34.rc6.git3.fc15.x86_64
Thread-Topic: PROBLEM: brcm80211 hangs on
 2.6.36-0.34.rc6.git3.fc15.x86_64
Thread-Index: Actm3lZprlv/VJjXQ5OsXz/i8Ah1OgAL31Lg
Message-ID: <7A94256FD72B884D9E7C55586C3CBCEE1381EE4B69@SJEXCHCCR01.corp.ad.broadcom.com>
References: <20101008065810.GA1680@constitution.bos.jonmasters.org>
 <1286538243.21485.298.camel@constitution.bos.jonmasters.org>
In-Reply-To: <1286538243.21485.298.camel@constitution.bos.jonmasters.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
MIME-Version: 1.0
X-WSS-ID: 60B187273KC130034165-01-01
Content-Type: text/plain;
 charset=utf-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id o98HjcQ6005101

Thanks for the input.

The 4313 (Device ID 4327) is pretty solid on the 32 bit staging-next kernel (loads, runs
for days, no issues, etc).

On the other hand, I haven't been using anything other than that kernel recently so its 
very, very likely there are problems with other kernels, especially 64 bit which I haven't even 
attempted yet (but will of course). Please do try out the 32 bit staging-next kernel and let me know how it goes.

Yeah, turning on msglevel produces more (and possibly *much* more) output.  

Let me know what you find,
Thanks
brett

> -----Original Message-----
> From: Jon Masters [mailto:jonathan@jonmasters.org]
> Sent: Friday, October 08, 2010 4:44 AM
> To: linux-wireless@vger.kernel.org
> Cc: Brett Rudley; Henry Ptasinski; Nohee Ko; Jon Masters; LKML
> Subject: Re: PROBLEM: brcm80211 hangs on 2.6.36-0.34.rc6.git3.fc15.x86_64
> 
> On Fri, 2010-10-08 at 02:58 -0400, Jon Masters wrote:
> 
> > I tried building the new brcm80211 driver from staging-next on Fedora
> > rawhide kernel 2.6.36-0.34.rc6.git3.fc15.x86_64. Now, of course, it's
> > not the staging-next kernel (I'll try that now this doesn't work) but
> > perhaps this report will still be of use to the Broadcom/other wireless
> folks.
> 
> I pulled the latest staging-next onto Linus' latest git tree and still
> experience problems with the driver. It seems that the first attempt to
> actually transmit results in the system locking hard. Once again, I am
> attaching the output from running a netconsole (due to the box I'm on,
> it's an attachment this time, sorry about that - don't trust evolution)
> where the trace is basically the same as the original trace I posted.
> 
> NOTE: in both cases, the driver is loaded with "msglevel=2 phymsglevel=2"
> which (although not documented) suggests to enable tracing, and does
> certainly yield more debugging output.
> 
> Jon.

ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
