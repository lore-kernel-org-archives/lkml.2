Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932147Ab1EESpn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 May 2011 14:45:43 -0400
Received: from mailb.microsoft.com ([131.107.115.215]:41580 "EHLO
	smtp.microsoft.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932072Ab1EESpm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 May 2011 14:45:42 -0400
From: Hank Janssen <hjanssen@microsoft.com>
To: "jdossantos@docs.homelinux.org" <jdossantos@docs.homelinux.org>
CC: KY Srinivasan <kys@microsoft.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: Error in Hyper-V modules hv_vmbus
Thread-Topic: Error in Hyper-V modules hv_vmbus
Thread-Index: AQHMCkBpETUemc5uTUuEnNLkft8sE5R8045QgAHGp4CAAGSWgP//lEgw
Date: Thu, 5 May 2011 18:45:39 +0000
Message-ID: <8AFC7968D54FB448A30D8F38F259C562498A5DD5@TK5EX14MBXC114.redmond.corp.microsoft.com>
References: <0e67fbb5ce27bd8d1210f0b7b8d5069c@docs.homelinux.org>
 <8AFC7968D54FB448A30D8F38F259C562498A3FF3@TK5EX14MBXC114.redmond.corp.microsoft.com>
 <42a623fd771f05f5bcabec8d632673e3@docs.homelinux.org>
 <f814458e9b05dd1d3f22c5bffa3ea18a@docs.homelinux.org>
In-Reply-To: <f814458e9b05dd1d3f22c5bffa3ea18a@docs.homelinux.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [157.54.51.37]
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id p45Ijmxm007202



> -----Original Message-----
> From: linux-kernel-owner@vger.kernel.org [mailto:linux-kernel-
> owner@vger.kernel.org] On Behalf Of jdossantos@docs.homelinux.org
> Sent: Thursday, May 05, 2011 11:05 AM
> To: Hank Janssen
> Cc: KY Srinivasan; linux-kernel@vger.kernel.org
> Subject: RE: Error in Hyper-V modules hv_vmbus
> 
> > Yes in ubuntu server (i tested the newest version 11.04) there is no
> > problem, the hyper-v modules are compiled and activated
> > as default in the released kernel (2.6.38-8), network, timesync and
> > all others integrated components are working fine. This is the lsmod
> > output:
> > lsmod | grep hv_
> > hv_utils               12850  0
> > hv_netvsc              36467  0
> > hv_timesource          12423  0 [permanent]
> > hv_vmbus               50431  2 hv_utils,hv_netvsc
> >
> > Now I have downloaded the newest rc kernel and done the same steps
> > like in the debian installation, after a reboot I get same errors and
> > integrated components failed to works...Now I check the hyper-v
> > modules source from 2.6.38-8 ubuntu kernel and the new one
> >
> > Regards
> > Juan Dos Santos
> 
>  Ok, now I have setup again debian 6.0.1a and compiled the 2.6.39-rc6
>  kernel but with the hyper-v staging drivers from ubuntu kernel 2.6.38-8
>  source (just replaced the hv directory, I know maybe it's dirty :) ).
>  But now all is working fine! I have now a debian system with kernel
>  2.6.39-rc6 with all integrated components running..looks that the
>  hyper-v modules in the ubuntu kernel are more stable that in the newest
>  official rc kernel?!
> 
>  Regards
>  Juan

Juan,

I just spun up the debian VM and I downloaded the latest staging and the rc5 that
failed for you and I was about to compile it.

Let me see what happened between rc5 and rc6 to see what might have solved the
problem you were seeing.

I would say that in general the older kernels (certainly 35 and 36) are more stable
than mainline for our drivers. We are making so many changes to mainline right now 
and that sometimes there are a few bugs that creep in that we have not caught yet. 

They are not so much functional as structural changes.

But I would not recommend running it in production unless you like to live
dangerously. :)

Hank.



ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
