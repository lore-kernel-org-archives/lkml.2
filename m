Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753889Ab2LQToe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Dec 2012 14:44:34 -0500
Received: from www.linutronix.de ([62.245.132.108]:37264 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752863Ab2LQToc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Dec 2012 14:44:32 -0500
Date: Mon, 17 Dec 2012 20:44:31 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Mike Galbraith <bitbucket@online.de>
cc: LKML <linux-kernel@vger.kernel.org>,
        linux-rt-users <linux-rt-users@vger.kernel.org>
Subject: Re: [ANNOUNCE] 3.6.9-rt21
In-Reply-To: <1355764176.11540.19.camel@marge.simpson.net>
Message-ID: <alpine.LFD.2.02.1212172043390.3148@ionos>
References: <alpine.LFD.2.02.1212051659160.2701@ionos>  <1355543529.20987.6.camel@marge.simpson.net>  <alpine.LFD.2.02.1212171634070.3148@ionos> <1355764176.11540.19.camel@marge.simpson.net>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 17 Dec 2012, Mike Galbraith wrote:
> On Mon, 2012-12-17 at 16:35 +0100, Thomas Gleixner wrote: 
> > Bah. This reverse user/kernel priority nonsense really should go away!
> 
> Snort, I looked right at it too, looked perfectly fine :)

The real bad news is, that I talked to someone about that reverse prio
issue just a few hours before I committed that crime. Blergh!
