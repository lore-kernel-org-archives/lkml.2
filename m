Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759296Ab0E0ROF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 May 2010 13:14:05 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:40436 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754600Ab0E0ROA convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 May 2010 13:14:00 -0400
Subject: Re: [linux-pm] [PATCH 0/8] Suspend block api (version 8)
From: Peter Zijlstra <peterz@infradead.org>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Felipe Balbi <felipe.balbi@nokia.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       Arve =?ISO-8859-1?Q?Hj=F8nnev=E5g?= <arve@android.com>,
       "Paul@smtp1.linux-foundation.org" <Paul@smtp1.linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Florian Mickler <florian@mickler.org>,
       Linux OMAP Mailing List <linux-omap@vger.kernel.org>,
       Linux PM <linux-pm@lists.linux-foundation.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>
In-Reply-To: <Pine.LNX.4.44L0.1005271303190.3239-100000@iolanthe.rowland.org>
References: <Pine.LNX.4.44L0.1005271303190.3239-100000@iolanthe.rowland.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Thu, 27 May 2010 19:13:40 +0200
Message-ID: <1274980420.27810.5557.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2010-05-27 at 13:04 -0400, Alan Stern wrote:
> 
> Does this mean you believe "echo mem >/sys/power/state" is bad and
> should be removed?  Or "echo disk >/sys/power/state"?  They pay no
> attention to latencies or other requirements. 

Those are a whole different beast, those are basically a quick-off
button like thing. Forced suspend is conceptually a very different beast
from power-saving a running system.


