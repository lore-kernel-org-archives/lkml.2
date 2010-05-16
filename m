Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754725Ab0EPWpA (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 May 2010 18:45:00 -0400
Received: from www.tglx.de ([62.245.132.106]:34457 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754651Ab0EPWo7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 May 2010 18:44:59 -0400
Date: Mon, 17 May 2010 00:44:28 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Jacob Pan <jacob.jun.pan@linux.intel.com>
cc: LKML <linux-kernel@vger.kernel.org>, "H. Peter Anvin" <hpa@zytor.com>,
       Ingo Molnar <mingo@elte.hu>, Alan Cox <alan@linux.intel.com>,
       Arjan van de Ven <arjan@linux.intel.com>,
       Feng Tang <feng.tang@intel.com>
Subject: Re: [PATCH 6/8] x86/mrst: add vrtc driver which serves as a wall
 clock device
In-Reply-To: <1273873281-17489-7-git-send-email-jacob.jun.pan@linux.intel.com>
Message-ID: <alpine.LFD.2.00.1005170043310.3368@localhost.localdomain>
References: <1273873281-17489-1-git-send-email-jacob.jun.pan@linux.intel.com> <1273873281-17489-7-git-send-email-jacob.jun.pan@linux.intel.com>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 14 May 2010, Jacob Pan wrote:

> From: Feng Tang <feng.tang@intel.com>
> 
> Moorestown platform doesn't have a m146818 RTC device like traditional
> x86 PC, but a firmware emulated virtual RTC device(vrtc), which provides
> some basic RTC functions like get/set time. vrtc serves as the only
> wall clock device on Moorestown platform.

NAK for the very same reason as [5/8]

Thanks,

	tglx
