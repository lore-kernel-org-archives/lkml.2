Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757158Ab2IJKsZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Sep 2012 06:48:25 -0400
Received: from Chamillionaire.breakpoint.cc ([80.244.247.6]:41242 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752360Ab2IJKsV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Sep 2012 06:48:21 -0400
Date: Mon, 10 Sep 2012 12:48:13 +0200
From: Sebastian Andrzej Siewior <sebastian@breakpoint.cc>
To: Ben Minerds <puzzleduck@gmail.com>
Cc: balbi@ti.com, gregkh@linuxfoundation.org, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] usb: gadget: Conform with checkpatch -3 warnings, 1 error
Message-ID: <20120910104813.GA3054@breakpoint.cc>
References: <1347151835-19028-1-git-send-email-puzzleduck@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1347151835-19028-1-git-send-email-puzzleduck@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Sep 09, 2012 at 10:50:35AM +1000, Ben Minerds wrote:
> Removed 3 checkpatch.sh warnings and 1 error in
> drivers/usb/gadget/serial.c.
> -sizeof brackets x2
> -remove initialise to 0
> -pr_warning to pr_warn

I have a series pending which removes the last two chunks.

Sebastian
