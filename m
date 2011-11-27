Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751515Ab1K0J0R (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Nov 2011 04:26:17 -0500
Received: from out2.smtp.messagingengine.com ([66.111.4.26]:36486 "EHLO
	out2.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750900Ab1K0J0O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Nov 2011 04:26:14 -0500
X-Sasl-enc: Q2XX0KT6IgjwBZOvBRPmUu4bIoIWAnUQ0S3vXVEhvhUv 1322385970
Date: Sat, 26 Nov 2011 16:54:49 -0800
From: Greg KH <greg@kroah.com>
To: Jonathan Cameron <jic23@cam.ac.uk>
Cc: Hui Zhu <teawater@gmail.com>, Greg Kroah-Hartman <gregkh@suse.de>,
        Michael Hennerich <michael.hennerich@analog.com>,
        linux-iio@vger.kernel.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] fix build error of function iio_event_getfd
Message-ID: <20111127005449.GA8982@kroah.com>
References: <CANFwon20C9NC6GmWnwfSHcWOSFe-7fdt_QbCQQNhegieNeDUNA@mail.gmail.com>
 <a3c3695e-8a13-4e44-9660-0df049d86003@email.android.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a3c3695e-8a13-4e44-9660-0df049d86003@email.android.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Nov 26, 2011 at 09:19:34AM +0000, Jonathan Cameron wrote:
> Thanks but this is 7th fix I have seen.

And I sent an 8th one to Linus now, that's a bit smaller :)

thanks,

greg k-h
