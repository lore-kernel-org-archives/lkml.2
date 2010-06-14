Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755013Ab0FNAWw (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Jun 2010 20:22:52 -0400
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:44260 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754934Ab0FNAWu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Jun 2010 20:22:50 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Mon, 14 Jun 2010 09:18:23 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>,
       Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
       linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org,
       jbarnes@virtuousgeek.org
Subject: Re: [PATCH 2/4] x86: ioremap: fix physical address check
Message-Id: <20100614091823.34fac7a6.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <4C1275BF.3070605@zytor.com>
References: <4C11FF10.4060203@jp.fujitsu.com>
	<4C11FFC0.1030006@jp.fujitsu.com>
	<4C1275BF.3070605@zytor.com>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 11 Jun 2010 10:43:27 -0700
"H. Peter Anvin" <hpa@zytor.com> wrote:

> On 06/11/2010 02:20 AM, Kenji Kaneshige wrote:
> > If the physical address is too high to be handled by ioremap() in
> > x86_32 PAE (e.g. more than 36-bit physical address), ioremap() must
> > return error (NULL). However, current x86 ioremap try to map this too
> > high physical address, and it causes unexpected behavior.
> 
> What unexpected behavior?  It is perfectly legitimately to map such a
> high address in PAE mode.  We have a 36-bit kernel-imposed limit on
> *RAM* in 32-bit mode (because we can't manage more than that), but there
> is no reason it should apply to I/O.
> 

I'm sorry for lack of study. 
How to access it via mapped area by ioremap() ?

Thanks,
-Kame

