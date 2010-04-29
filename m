Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932111Ab0D3Qyk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Apr 2010 12:54:40 -0400
Received: from mail.gmx.net ([213.165.64.20]:50383 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1758021Ab0D3QyX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Apr 2010 12:54:23 -0400
X-Authenticated: #1587495
X-Provags-ID: V01U2FsdGVkX192q5opsHJ2b4hh5mLFpgkdKacvvK4u4c8UlAGSw5
	0aQb2VGo4vYFdK
From: "Stefan Lippers-Hollmann" <s.L-H@gmx.de>
To: "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: 2.6.34-rc5-git10: oops on Atom N270/ i945GSE upon shutdown with X86_MRST && APB_TIMER enabled
Date: Fri, 30 Apr 2010 00:07:34 +0200
User-Agent: KMail/1.13.2 (Linux/2.6.34-rc5-sidux-686; KDE/4.4.2; i686; ; )
Cc: linux-kernel@vger.kernel.org, Jacob Pan <jacob.jun.pan@intel.com>
References: <201004292143.29507.s.L-H@gmx.de> <4BD9F1FE.8010708@zytor.com>
In-Reply-To: <4BD9F1FE.8010708@zytor.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201004300007.36911.s.L-H@gmx.de>
X-Y-GMX-Trusted: 0
X-FuHaFi: 0.51000000000000001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi

On Friday 30 April 2010, H. Peter Anvin wrote:
> Could you apply this patch and verify that it solves your problem:
> 
> http://git.kernel.org/tip/ae7c9b70dcb4313ea3dbcc9a2f240dae6c2b50c0

I can confirm that this patch applied on top of 2.6.34-rc5-git10 fixes 
my shutdown problem; no further oops has shown within 20+ shutdowns so far,
while it was 100% reproducably before. Sorry that I didn't notice 
https://bugzilla.kernel.org/show_bug.cgi?id=15786 before.

Tested-by: Stefan Lippers-Hollmann <s.l-h@gmx.de>

> 	-hpa
> 
> On 04/29/2010 12:43 PM, Stefan Lippers-Hollmann wrote:
> > Hi
> > 
> > While testing kernel 2.6.34-rc5-git10 on an Acer Aspire One 110L netbook 
> > (Atom N270, i945GSE chipset, hyperthreading enabled and not configurable, 
> > BIOS 3309), I reproducably encounter the following oops while shutting down
> > (manual transcription below):
> > 
> > Pid: 2253, comm: halt Not Tainted 2.6.34-rc5-sidux-686 #1        /AOA110
> > EIP: 0060:[<c0121232>] EFLAGS: 00010202 CPU: 0
> > EIP is at apbt_cpuhp_notify+0x32/0x60
[...]

Thanks a lot
	Stefan Lippers-Hollmann
