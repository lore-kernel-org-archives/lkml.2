Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752551Ab2LUQaJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Dec 2012 11:30:09 -0500
Received: from www.linutronix.de ([62.245.132.108]:53209 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751601Ab2LUQaA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Dec 2012 11:30:00 -0500
Date: Fri, 21 Dec 2012 17:29:58 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Mike Galbraith <bitbucket@online.de>
cc: LKML <linux-kernel@vger.kernel.org>,
        linux-rt-users <linux-rt-users@vger.kernel.org>
Subject: Re: [ANNOUNCE] 3.6.11-rt24 (apocalypse release)c
In-Reply-To: <1356106865.4547.60.camel@marge.simpson.net>
Message-ID: <alpine.LFD.2.02.1212211729240.3148@ionos>
References: <alpine.LFD.2.02.1212211413200.3148@ionos> <1356106865.4547.60.camel@marge.simpson.net>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 21 Dec 2012, Mike Galbraith wrote:
> Just got this apocalypse day hiccup.

Can you revert the block chill patch ?
