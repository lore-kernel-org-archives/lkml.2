Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751678Ab1GWHnR (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Jul 2011 03:43:17 -0400
Received: from www.linutronix.de ([62.245.132.108]:48492 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750949Ab1GWHnO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Jul 2011 03:43:14 -0400
Date: Sat, 23 Jul 2011 09:43:12 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Ed Tomlinson <edt@aei.ca>
cc: LKML <linux-kernel@vger.kernel.org>,
        linux-rt-users <linux-rt-users@vger.kernel.org>
Subject: Re: [ANNOUNCE] 3.0-rt1
In-Reply-To: <201107221923.17455.edt@aei.ca>
Message-ID: <alpine.LFD.2.02.1107230942540.2702@ionos>
References: <alpine.LFD.2.02.1107222203400.2702@ionos> <201107221923.17455.edt@aei.ca>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 22 Jul 2011, Ed Tomlinson wrote:

> On Friday 22 July 2011 16:37:24 Thomas Gleixner wrote:
> > Dear RT Folks,
> > 
> > I'm pleased to announce the 3.0-rt1 release.
> 
> Thomas,
> 
> It does not build here with CONFIG_RCU_TORTURE_TEST=m

Fix queued for -rt2.

Thanks,

	tglx
