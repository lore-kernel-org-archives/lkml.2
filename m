Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756996Ab2B1KKD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Feb 2012 05:10:03 -0500
Received: from am1ehsobe001.messaging.microsoft.com ([213.199.154.204]:45234
	"EHLO AM1EHSOBE004.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752954Ab2B1KKA convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Feb 2012 05:10:00 -0500
X-SpamScore: -10
X-BigFish: VS-10(zz9371I542M1432N4015Izz1202hzz8275dhz2dh2a8h668h839h8e2h8e3h946hbe9k)
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
From: Liu Shengzhou-B36685 <B36685@freescale.com>
To: Ben Collins <benmcollins13@gmail.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [Regression] powerpc/usb: fix issue of CPU halt when missing
 USB PHY clock
Thread-Topic: [Regression] powerpc/usb: fix issue of CPU halt when missing
 USB PHY clock
Thread-Index: AQHM9WpvwudxTzHmB0OzNbpGn/N0m5ZSFGRQ
Date: Tue, 28 Feb 2012 10:09:56 +0000
Message-ID: <3F453DDFF675A64A89321A1F3528102170B796@039-SN1MPN1-004.039d.mgd.msft.net>
References: <12BC8F06-26EE-4A58-8F0B-6D39C0DD7360@gmail.com>
In-Reply-To: <12BC8F06-26EE-4A58-8F0B-6D39C0DD7360@gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.193.20.89]
Content-Type: text/plain; charset="Windows-1252"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> -----Original Message-----
> From: Ben Collins [mailto:benmcollins13@gmail.com]
> Sent: Tuesday, February 28, 2012 12:11 AM
> To: Liu Shengzhou-B36685
> Cc: linux-kernel@vger.kernel.org
> Subject: [Regression] powerpc/usb: fix issue of CPU halt when missing
> USB PHY clock
> 
> Hello,
> 
> The patch that checks the CTRL_PHY_CLK_VALID bit is failing incorrectly
> on my system (P4080DS). If I revert it, my system goes back to working
> correctly, but as is, it fails and wont allow my USB to work properly.
> 
> I've tried adding a loop to poll this bit 10,000 times with a udelay(1)
> on each loop and it still fails, so it doesn't appear to be a timing
> issue.
> 
> Is this check valid for all systems?
> 

This check is valid for P3060/P3041/P5020/P1023 platform.
on some platforms, there is this bit, but not on other some platforms.
For P4080, just revert this patch, then USB is able to work.
I'll post a new patch to fix it after getting some confirmations from silicon team.

Thanks,
Shengzhou


