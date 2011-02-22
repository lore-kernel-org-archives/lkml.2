Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754564Ab1BVRRa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Feb 2011 12:17:30 -0500
Received: from www.tglx.de ([62.245.132.106]:48140 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751299Ab1BVRR3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Feb 2011 12:17:29 -0500
Date: Tue, 22 Feb 2011 18:17:25 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: "Schaefer Dr, Frank-Rene ()" <fschaef9@visteon.com>
cc: linux-kernel@vger.kernel.org
Subject: RE: Interrupt Latencies
In-Reply-To: <060E4307CE6CA14BB4F7B4A25ECA052904BB6E98@VEUMBV03.vistcorp.ad.visteon.com>
Message-ID: <alpine.LFD.2.00.1102221814430.2701@localhost6.localdomain6>
References: <060E4307CE6CA14BB4F7B4A25ECA052904B73AD1@VEUMBV03.vistcorp.ad.visteon.com> <alpine.LFD.2.00.1102221527180.2701@localhost6.localdomain6> <060E4307CE6CA14BB4F7B4A25ECA052904BB6E98@VEUMBV03.vistcorp.ad.visteon.com>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 22 Feb 2011, Schaefer Dr, Frank-Rene () wrote:

Please do not top post.

> We are using GPIO pins and map them to IRQ. 

How are the GPIO pins accessed ? Are they memory mapped registers or what ?

> The underlying driver seems to use message signaled interrupts.

That does not answer which driver is involved. W/o seing the code I
can't tell much.

Thanks,

	tglx

