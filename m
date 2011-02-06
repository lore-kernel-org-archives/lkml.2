Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751057Ab1BFFAL (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Feb 2011 00:00:11 -0500
Received: from kroah.org ([198.145.64.141]:38020 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750751Ab1BFFAK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Feb 2011 00:00:10 -0500
Date: Sat, 5 Feb 2011 21:00:59 -0800
From: Greg KH <greg@kroah.com>
To: Nitin Gupta <ngupta@vflare.org>
Cc: Pekka Enberg <penberg@cs.helsinki.fi>,
        Linux Driver Project <devel@linuxdriverproject.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] zram: fix data corruption issue
Message-ID: <20110206050059.GA4465@kroah.com>
References: <1296956060-13594-1-git-send-email-ngupta@vflare.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1296956060-13594-1-git-send-email-ngupta@vflare.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Feb 05, 2011 at 08:34:20PM -0500, Nitin Gupta wrote:
> In zram_read() and zram_write() we were not incrementing the
> index number and thus were reading/writing values from/to
> incorrect sectors on zram disk, resulting in data corruption.

Is this something that needs to go into .38 or can it wait until .39?

thanks,

greg k-h
