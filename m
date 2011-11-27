Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751434Ab1K0JWz (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Nov 2011 04:22:55 -0500
Received: from out2.smtp.messagingengine.com ([66.111.4.26]:53082 "EHLO
	out2.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750900Ab1K0JWx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Nov 2011 04:22:53 -0500
X-Sasl-enc: 4opBvNZQIUerS5XLmVMXqpwyB654G1d/aXZpNIcKqDQQ 1322385771
Date: Sat, 26 Nov 2011 16:43:25 -0800
From: Greg KH <greg@kroah.com>
To: Jesper Juhl <jj@chaosbits.net>
Cc: linux-iio@vger.kernel.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        Michael Hennerich <michael.hennerich@analog.com>,
        Greg Kroah-Hartman <gregkh@suse.de>,
        Jonathan Cameron <jic23@cam.ac.uk>
Subject: Re: [PATCH] [staging] iio, adc: Do not leak memory in
 ad7280_event_handler()
Message-ID: <20111127004325.GA21259@kroah.com>
References: <alpine.LNX.2.00.1111062246580.5763@swampdragon.chaosbits.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LNX.2.00.1111062246580.5763@swampdragon.chaosbits.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Nov 06, 2011 at 10:49:22PM +0100, Jesper Juhl wrote:
> If ad7280_read_all_channels() returns <0 then we'll leak the memory
> allocated to 'channels' when we return and that variable goes out of
> scope.
> This patch fixes the leak.

This patch no longer applies to my tree, can you redo it against the
next linux-next release and resend it?

thanks,

greg k-h
