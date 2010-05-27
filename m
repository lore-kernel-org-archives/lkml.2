Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932576Ab0E0RcZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 May 2010 13:32:25 -0400
Received: from casper.infradead.org ([85.118.1.10]:34711 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756757Ab0E0RcW convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 May 2010 13:32:22 -0400
Subject: Re: [linux-pm] [PATCH 0/8] Suspend block api (version 8)
From: Peter Zijlstra <peterz@infradead.org>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Felipe Balbi <felipe.balbi@nokia.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       Arve =?ISO-8859-1?Q?Hj=F8nnev=E5g?= <arve@android.com>,
       LKML <linux-kernel@vger.kernel.org>,
       Florian Mickler <florian@mickler.org>,
       Linux OMAP Mailing List <linux-omap@vger.kernel.org>,
       Linux PM <linux-pm@lists.linux-foundation.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>
In-Reply-To: <Pine.LNX.4.44L0.1005271327560.3239-100000@iolanthe.rowland.org>
References: <Pine.LNX.4.44L0.1005271327560.3239-100000@iolanthe.rowland.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Thu, 27 May 2010 19:32:13 +0200
Message-ID: <1274981533.27810.5624.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2010-05-27 at 13:29 -0400, Alan Stern wrote:
> 
> They may be different conceptually.  Nevertheless, Android uses forced 
> suspend as a form of power saving.  Until better mechanisms are in 
> place, it makes sense. 

So let them, doesn't mean we have to merge it. Or will you saw your foot
off too if google were to promotes it?
