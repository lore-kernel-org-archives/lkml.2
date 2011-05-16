Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754404Ab1EPTKs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 May 2011 15:10:48 -0400
Received: from ch1outboundpool.messaging.microsoft.com ([216.32.181.185]:50229
	"EHLO ch1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753890Ab1EPTKq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 May 2011 15:10:46 -0400
X-SpamScore: -13
X-BigFish: VPS-13(zz1b0bM1432N98dKzz1202hzzz32i668h839h61h)
X-Spam-TCS-SCL: 0:0
X-Forefront-Antispam-Report: KIP:(null);UIP:(null);IPVD:NLI;H:ausb3twp01.amd.com;RD:none;EFVD:NLI
X-WSS-ID: 0LLAYLR-01-00U-02
X-M-MSG: 
Date: Mon, 16 May 2011 21:10:13 +0200
From: Hans Rosenfeld <hans.rosenfeld@amd.com>
To: Ingo Molnar <mingo@elte.hu>
CC: "hpa@zytor.com" <hpa@zytor.com>, "x86@kernel.org" <x86@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [RFC v3 0/8] x86, xsave: rework of extended state handling, LWP
 support
Message-ID: <20110516191012.GA575@escobedo.osrc.amd.com>
References: <4D91FA76.1010908@zytor.com>
 <1302018656-586370-1-git-send-email-hans.rosenfeld@amd.com>
 <20110407072305.GA20291@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20110407072305.GA20291@elte.hu>
Organization: Advanced Micro Devices GmbH, Einsteinring 24, 85609 Dornach b.
 Muenchen; Geschaeftsfuehrer: Andrew Bowd, Alberto Bozzo; Sitz: Dornach,
 Gemeinde Aschheim, Landkreis Muenchen; Registergericht Muenchen, HRB Nr.
 43632
User-Agent: Mutt/1.5.21 (2010-09-15)
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Thu, Apr 07, 2011 at 03:23:05AM -0400, Ingo Molnar wrote:
> 
> FYI, the bits in tip:x86/xsave crash on boot on an AMD X2 testbox:

> Full crashlog and kernel config attached. I've excluded x86/save from 
> tip:master for now.

this issue has been fixed a few weeks ago.

Are there any plans to include x86/xsave into tip:master again?


Hans


-- 
%SYSTEM-F-ANARCHISM, The operating system has been overthrown

