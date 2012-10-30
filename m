Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757413Ab2J3TTA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Oct 2012 15:19:00 -0400
Received: from mail-pa0-f46.google.com ([209.85.220.46]:42530 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756092Ab2J3TS6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Oct 2012 15:18:58 -0400
Date: Tue, 30 Oct 2012 12:18:55 -0700
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
Cc: Nitin Gupta <ngupta@vflare.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] zram: factor-out zram_decompress_page() function
Message-ID: <20121030191855.GB1868@kroah.com>
References: <20121030090319.GB5052@swordfish.minsk.epam.com>
 <20121030180439.GA3350@kroah.com>
 <20121030185842.GC2454@swordfish>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121030185842.GC2454@swordfish>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 30, 2012 at 09:58:42PM +0300, Sergey Senozhatsky wrote:
>   zram: factor-out zram_decompress_page() function

What's with the indentation?

And including the Subject: again here?

> 
>   zram_bvec_read() shared decompress functionality with zram_read_before_write() function.
>   Factor-out and make commonly used zram_decompress_page() function, which also simplified
>   error handling in zram_bvec_read().
> 
>   Signed-off-by: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>

Where did Nitin's ack go?

I would have to edit these by hand to apply them, which isn't ok.
Please fix this up, add Nitin's acks, and resend properly.

thanks,

greg k-h
