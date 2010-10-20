Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752952Ab0JTOFH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Oct 2010 10:05:07 -0400
Received: from lo.gmane.org ([80.91.229.12]:44533 "EHLO lo.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752102Ab0JTOFG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Oct 2010 10:05:06 -0400
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: Markus Trippelsdorf <markus@trippelsdorf.de>
Subject: Re: [RFC/RFT PATCH] sched: automated per tty task groups
Followup-To: gmane.linux.kernel
Date: Wed, 20 Oct 2010 15:55:25 +0200
Message-ID: <i9msce$97o$1@dough.gmane.org>
References: <1287479765.9920.9.camel@marge.simson.net>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7Bit
X-Complaints-To: usenet@dough.gmane.org
X-Gmane-NNTP-Posting-Host: 95-88-18-139-dynip.superkabel.de
User-Agent: KNode/4.4.6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mike Galbraith wrote:

> Comments, suggestions etc highly welcome.

I've tested your patch and it runs smoothly on my machine.
However I had several NULL pointer dereference BUGs that happened when I 
left X or rebooted my system. I think this is caused by your patch. 
There is nothing in the logs unfortunately, but I scribbled down the 
following by hand (not the whole trace, I'm too lazy):

BUG: unable to handle NULL pointer dereference at 0..038
IP:   pick_next_task_fair 0xa7/0x1a0
...
Call Trace: schedule 
...





