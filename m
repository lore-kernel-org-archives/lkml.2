Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932216Ab0E0TUH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 May 2010 15:20:07 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:55392 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1757908Ab0E0TUE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 May 2010 15:20:04 -0400
Date: Thu, 27 May 2010 20:27:12 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Matthew Garrett <mjg59@srcf.ucam.org>,
       Peter Zijlstra <peterz@infradead.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       LKML <linux-kernel@vger.kernel.org>,
       Florian Mickler <florian@mickler.org>, <felipe.balbi@nokia.com>,
       Linux OMAP Mailing List <linux-omap@vger.kernel.org>,
       Linux PM <linux-pm@lists.linux-foundation.org>
Subject: Re: [linux-pm] [PATCH 0/8] Suspend block api (version 8)
Message-ID: <20100527202712.181fd172@lxorguk.ukuu.org.uk>
In-Reply-To: <Pine.LNX.4.44L0.1005271449160.3239-100000@iolanthe.rowland.org>
References: <20100527175719.GD3543@srcf.ucam.org>
	<Pine.LNX.4.44L0.1005271449160.3239-100000@iolanthe.rowland.org>
X-Mailer: Claws Mail 3.7.5 (GTK+ 2.18.9; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Rather than continue going around in circles, let's agree that what the 
> Android people want is a new version of forced suspend -- not a 

I don't think this is true. I think that is the root of the problem.

I don't disagree with the user experience they are trying to create or
the fact something is needed to make it possible (if it turns out we
can't already do it).

Forced suspend is sticking stuff in running state into suspend

Power management models (such as Thomas ARM box) which we know work are
'when nothing is running' into suspend.

So for me the real question on that side of this specific case is 'how
do you make sure those tasks are idle when you need them to be'

QoS ?
Spanking them from user space ?
Drivers enforcing policy elements by blocking tasks ?

Alan
