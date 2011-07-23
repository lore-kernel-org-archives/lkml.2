Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751885Ab1GWHx3 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Jul 2011 03:53:29 -0400
Received: from www.linutronix.de ([62.245.132.108]:55606 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751052Ab1GWHxW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Jul 2011 03:53:22 -0400
Date: Sat, 23 Jul 2011 09:53:20 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Mike Galbraith <efault@gmx.de>
cc: LKML <linux-kernel@vger.kernel.org>,
        linux-rt-users <linux-rt-users@vger.kernel.org>
Subject: Re: [ANNOUNCE] 3.0-rt1
In-Reply-To: <1311407402.8453.3.camel@marge.simson.net>
Message-ID: <alpine.LFD.2.02.1107230952520.2702@ionos>
References: <alpine.LFD.2.02.1107222203400.2702@ionos> <1311407402.8453.3.camel@marge.simson.net>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 23 Jul 2011, Mike Galbraith wrote:

> On Fri, 2011-07-22 at 22:37 +0200, Thomas Gleixner wrote:
> > Dear RT Folks,
> > 
> > I'm pleased to announce the 3.0-rt1 release.
> 
> drivers-dca-convert-dcalock-to-raw.patch needs incremental update.

Indeed. Thanks for spotting.
