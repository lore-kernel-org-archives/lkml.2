Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753390Ab1FLMEr (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Jun 2011 08:04:47 -0400
Received: from lucidpixels.com ([75.144.35.66]:34027 "EHLO lucidpixels.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753233Ab1FLMEq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Jun 2011 08:04:46 -0400
Date: Sun, 12 Jun 2011 08:04:43 -0400 (EDT)
From: Justin Piszcz <jpiszcz@lucidpixels.com>
To: Thomas Gleixner <tglx@linutronix.de>
cc: LKML <linux-kernel@vger.kernel.org>, Alan Piszcz <ap@solarrain.com>,
        Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>
Subject: Re: 2.6.39: crash w/threadirqs option enabled
In-Reply-To: <alpine.DEB.2.02.1106100854250.23139@p34.internal.lan>
Message-ID: <alpine.DEB.2.02.1106120759270.4186@p34.internal.lan>
References: <alpine.DEB.2.02.1105200405210.24033@p34.internal.lan> <alpine.LFD.2.02.1105201445300.3078@ionos> <alpine.DEB.2.02.1105200850080.19553@p34.internal.lan> <alpine.LFD.2.02.1105201528500.3078@ionos> <alpine.DEB.2.02.1105200945300.19553@p34.internal.lan>
 <alpine.LFD.2.02.1105201712501.3078@ionos> <alpine.DEB.2.02.1105201210030.19553@p34.internal.lan> <alpine.LFD.2.02.1105201819310.3078@ionos> <alpine.DEB.2.02.1106100414550.32450@p34.internal.lan> <alpine.LFD.2.02.1106101450030.11814@ionos>
 <alpine.DEB.2.02.1106100854250.23139@p34.internal.lan>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Fri, 10 Jun 2011, Justin Piszcz wrote:

>
>

Hi,

It crashed again with the patch, so it must be something else when it
happened, I was not able to get any output since i was in X.

Will leave X off, console/monitor on and disconnect those USB devices
I mentioned earlier and see if the problem persists.

The call trace in the picture the last time I was able to get a screen
shot was @ blk_peek_request and scsi_request_fn.
http://home.comcast.net/~jpiszcz/20110528/2639-ss1.jpg

I will disconnect the USB devices I mentioned earlier and see if the issues
persist.

Justin.

