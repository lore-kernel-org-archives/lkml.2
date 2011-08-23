Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755630Ab1HWW2T (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Aug 2011 18:28:19 -0400
Received: from out3.smtp.messagingengine.com ([66.111.4.27]:35708 "EHLO
	out3.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755058Ab1HWW2O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Aug 2011 18:28:14 -0400
X-Sasl-enc: QTlWUQagKcGlGBjQzLsQrxlHKw0SJpQX0la9YsssGyrG 1314138493
Date: Tue, 23 Aug 2011 15:27:38 -0700
From: Greg KH <greg@kroah.com>
To: Akshay Joshi <me@akshayjoshi.com>
Cc: Pavel Machek <pavel@ucw.cz>, Greg Kroah-Hartman <gregkh@suse.de>,
        Pekka Enberg <penberg@kernel.org>, Ilia Mirkin <imirkin@alum.mit.edu>,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/9] Staging: Winbond: Fix case statements in wb35reg.c.
Message-ID: <20110823222738.GE15721@kroah.com>
References: <1313454275-5604-1-git-send-email-me@akshayjoshi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1313454275-5604-1-git-send-email-me@akshayjoshi.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 15, 2011 at 08:24:27PM -0400, Akshay Joshi wrote:
> Split the case statement and the code that is executed if the condition
> is met so that it passes checkpatch.pl and conforms to the kernel code
> style.

Not quite.

Please put the 'break;' on a new line for every case statement.

Care to redo this whole series based on the review comments you got so
far and resend them?

thanks,

greg k-h
