Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757556Ab0FETwZ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Jun 2010 15:52:25 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:60037 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757267Ab0FETwY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Jun 2010 15:52:24 -0400
Subject: Re: [linux-pm] [PATCH 0/8] Suspend block api (version 8)
From: Peter Zijlstra <peterz@infradead.org>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Felipe Contreras <felipe.contreras@gmail.com>,
       Florian Mickler <florian@mickler.org>,
       James Bottomley <James.Bottomley@suse.de>,
       Arve =?ISO-8859-1?Q?Hj=F8nnev=E5g?= <arve@android.com>, tytso@mit.edu,
       LKML <linux-kernel@vger.kernel.org>,
       Linux PM <linux-pm@lists.linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Linux OMAP Mailing List <linux-omap@vger.kernel.org>,
       felipe.balbi@nokia.com, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Brian Swetland <swetland@google.com>,
       Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <201006052139.31253.rjw@sisk.pl>
References: <20100527222514.0a1710bf@lxorguk.ukuu.org.uk>
	 <201006052104.05324.rjw@sisk.pl> <1275765379.1645.532.camel@laptop>
	 <201006052139.31253.rjw@sisk.pl>
Content-Type: text/plain; charset="UTF-8"
Date: Sat, 05 Jun 2010 21:52:16 +0200
Message-ID: <1275767536.1645.534.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2010-06-05 at 21:39 +0200, Rafael J. Wysocki wrote:
> 
> There is a number of kernel users that depend on Android user space
> (phone vendors using Android on their hardware, but providing their own
> drivers), so I don't think we really can identify Android with Google in that
> respect.

I don't see why we can't merge the platform code and drivers without
suspend blockers. Google can patch them back in on their side if they
want to.



