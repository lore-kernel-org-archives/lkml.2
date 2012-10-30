Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965202Ab2J3SEo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Oct 2012 14:04:44 -0400
Received: from mail-da0-f46.google.com ([209.85.210.46]:55890 "EHLO
	mail-da0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759939Ab2J3SEm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Oct 2012 14:04:42 -0400
Date: Tue, 30 Oct 2012 11:04:39 -0700
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
Cc: Nitin Gupta <ngupta@vflare.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] zram: permit sleeping while in pool zs_malloc()
Message-ID: <20121030180439.GA3350@kroah.com>
References: <20121030090319.GB5052@swordfish.minsk.epam.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121030090319.GB5052@swordfish.minsk.epam.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 30, 2012 at 12:03:19PM +0300, Sergey Senozhatsky wrote:
>     zram: permit sleeping while in pool zs_malloc()

2/2?  Huh?  Where is 1/2?

I have a raft of patches from you, all out of order, and full of
responses from Nitin, and so, I really have no idea what should and
should not be applied here.

So, I'm dropping them all.  Please work with Nitin to get a series of
patches that are acceptable and resend them with the proper numbering.

thanks,

greg k-h
