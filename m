Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753533Ab0FWX2m (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jun 2010 19:28:42 -0400
Received: from mail.gmx.net ([213.165.64.20]:60350 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751470Ab0FWX2l (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jun 2010 19:28:41 -0400
X-Authenticated: #12255092
X-Provags-ID: V01U2FsdGVkX18fPYZW8rkf7Qv5X1IadcV18y3DKcVT9AFcBvZgxN
	2rfzeDnFNKFQ/d
From: Peter =?iso-8859-1?q?H=FCwe?= <PeterHuewe@gmx.de>
To: Russell King <linux@arm.linux.org.uk>
Subject: Re: [PATCH] arm/include: Fix missing semicolon in module.h
Date: Thu, 24 Jun 2010 01:28:41 +0200
User-Agent: KMail/1.12.4 (Linux/2.6.34; KDE/4.3.5; x86_64; ; )
Cc: Phil Carmody <ext-phil.2.carmody@nokia.com>,
       Catalin Marinas <catalin.marinas@arm.com>,
       "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
References: <201006161932.00542.PeterHuewe@gmx.de> <20100617092419.GI17639@pcarmody-desktop>
In-Reply-To: <20100617092419.GI17639@pcarmody-desktop>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201006240128.41556.PeterHuewe@gmx.de>
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Donnerstag 17 Juni 2010 11:24:19 schrieb Phil Carmody:
> On 16/06/10 19:32 +0200, ext Peter Huewe wrote:
> > From: Peter Huewe <peterhuewe@gmx.de>
> >
> > This patch fixes a missing semicolon which introduced buildfailures [2]
> > for almost every arm defconfig, introduced by patch cecaa4c6b [1]
> >
> > This issue arises only if CONFIG_ARM_UNWIND is not set.
> >
> > Signed-off-by: Peter Huewe <peterhuewe@gmx.de>
> 
> My bad, sorry.
> 
> Acked-by: Phil Carmody <ext-phil.2.carmody@nokia.com>


Any updates on this one ? 

Peter
