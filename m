Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756528Ab2FTKvz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jun 2012 06:51:55 -0400
Received: from zoneX.GCU-Squad.org ([194.213.125.0]:30585 "EHLO
	services.gcu-squad.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756431Ab2FTKvx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jun 2012 06:51:53 -0400
Date: Wed, 20 Jun 2012 12:51:24 +0200
From: Jean Delvare <khali@linux-fr.org>
To: Daniel Kurtz <djkurtz@chromium.org>
Cc: ben-linux@fluff.org, seth.heasley@intel.com, ben@decadent.org.uk,
        David.Woodhouse@intel.com, linux-i2c@vger.kernel.org,
        linux-kernel@vger.kernel.org, olofj@chromium.org, bleung@chromium.org
Subject: Re: [PATCH 2/3 v2] i2c: i801: enable irq for i801 smbus
 transactions
Message-ID: <20120620125124.794f3339@endymion.delvare>
In-Reply-To: <CAGS+omDLYvqM69MFbU-pE6mAKT3tQnRw08aqbK73-hUBjOmZ0w@mail.gmail.com>
References: <1325847502-17841-1-git-send-email-djkurtz@chromium.org>
	<1325847502-17841-3-git-send-email-djkurtz@chromium.org>
	<20120619204704.69454016@endymion.delvare>
	<20120620105847.65cf37f2@endymion.delvare>
	<CAGS+omDLYvqM69MFbU-pE6mAKT3tQnRw08aqbK73-hUBjOmZ0w@mail.gmail.com>
X-Mailer: Claws Mail 3.7.10 (GTK+ 2.24.7; x86_64-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 20 Jun 2012 18:21:47 +0800, Daniel Kurtz wrote:
> Thanks for taking a look at these patches... and for testing them!

Thanks a lot for your patience!

> They were from more than 7 months ago, so it will take me a little
> time to context switch back to the point where I can really digest
> your feedback and update and test them again myself.  But, I wanted to
> just let you know that I am reading your review comments, and will get
> to it as soon as I can.

Great, thanks. On my end, I'll do some more testing on the hardware I
have, and post comments if I have more.

> Speaking of which, I have only seen comments on patches 1 & 2 so far.
> Any comments on patch 3?

Didn't have the time yesterday, I'll comment on it today. Actually it's
the very first item on my to-do list for the afternoon.

-- 
Jean Delvare
