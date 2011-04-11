Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758040Ab1DKJi6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Apr 2011 05:38:58 -0400
Received: from gate.crashing.org ([63.228.1.57]:42053 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757348Ab1DKJi4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Apr 2011 05:38:56 -0400
Subject: Re: [PATCH] x86/ce4100: add reg property to bridges
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Cc: linux-pci@vger.kernel.org, linux-arch@vger.kernel.org,
        linux-kernel@vger.kernel.org, davem@davemloft.net, monstr@monstr.eu,
        tglx@linutronix.de
In-Reply-To: <20110411072340.GA4018@linutronix.de>
References: <1302146796-26825-1-git-send-email-benh@kernel.crashing.org>
	 <1302146796-26825-2-git-send-email-benh@kernel.crashing.org>
	 <20110407121315.GA9204@linutronix.de> <1302213159.2458.43.camel@pasglop>
	 <20110411072340.GA4018@linutronix.de>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 11 Apr 2011 19:38:41 +1000
Message-ID: <1302514721.28876.12.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2011-04-11 at 09:23 +0200, Sebastian Andrzej Siewior wrote:
> * Benjamin Herrenschmidt | 2011-04-08 07:52:39 [+1000]:
> 
> >Thanks. Are you sending that independently or do you want me to put it
> >in my series before the patch that would "break" it ?
> 
> I would prefer to get it into 39 so I don't have a device tree which
> does not work on a later kernel version.

I've put merged the patch in my series. That's easier for testing.

Cheers,
Ben.


