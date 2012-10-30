Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965484Ab2J3SwL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Oct 2012 14:52:11 -0400
Received: from mail-lb0-f174.google.com ([209.85.217.174]:37902 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934236Ab2J3SwG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Oct 2012 14:52:06 -0400
Date: Tue, 30 Oct 2012 21:49:11 +0300
From: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Nitin Gupta <ngupta@vflare.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] zram: permit sleeping while in pool zs_malloc()
Message-ID: <20121030184911.GA2454@swordfish>
References: <20121030090319.GB5052@swordfish.minsk.epam.com>
 <20121030180439.GA3350@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121030180439.GA3350@kroah.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On (10/30/12 11:04), Greg Kroah-Hartman wrote:
> On Tue, Oct 30, 2012 at 12:03:19PM +0300, Sergey Senozhatsky wrote:
> >     zram: permit sleeping while in pool zs_malloc()
> 
> 2/2?  Huh?  Where is 1/2?
> 
> I have a raft of patches from you, all out of order, and full of
> responses from Nitin, and so, I really have no idea what should and
> should not be applied here.
> 
> So, I'm dropping them all.  Please work with Nitin to get a series of
> patches that are acceptable and resend them with the proper numbering.
> 

those were two separate series.

the first one:

[PATCH 1/2] zram: factor-out zram_decompress_page() function
[PATCH 2/2] zram: handle mem suffixes in disk size zram_sysfs parameter

ACKed by Nitin.



the second one

[PATCH 2/2] zram: permit sleeping while in pool zs_malloc()
[PATCH 1/2] zram: forbid IO operations from within zram_init_device()  -- droppped by me.


I'll resend first two and next time will make sure not to spam your box. sorry.


	-ss

> thanks,
> 
> greg k-h
> 
