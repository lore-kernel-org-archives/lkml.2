Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756274Ab0KVBMd (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Nov 2010 20:12:33 -0500
Received: from kroah.org ([198.145.64.141]:56568 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756316Ab0KVBMa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Nov 2010 20:12:30 -0500
Date: Sun, 21 Nov 2010 17:09:14 -0800
From: Greg KH <greg@kroah.com>
To: Kent Overstreet <kent.overstreet@gmail.com>
Cc: linux-bcache@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org
Subject: Re: Bcache version 9
Message-ID: <20101122010914.GB7688@kroah.com>
References: <20101121140808.GA6429@moria>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101121140808.GA6429@moria>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Nov 21, 2010 at 06:09:34AM -0800, Kent Overstreet wrote:
> +++ b/Documentation/bcache.txt

For new sysfs files, please create Documentation/ABI files.

> +All configuration is done via sysfs. To use sde to cache md1, assuming the
> +SSD's erase block size is 128k:
> +
> +  make-bcache -b128k /dev/sde
> +  echo "/dev/sde" > /sys/kernel/bcache/register_cache
> +  echo "<UUID> /dev/md1" > /sys/kernel/bcache/register_dev

/sys/kernel/bcache/?  Really?

Come on, shouldn't this be somewhere else?  You only have 1 file here,
right?

Shouldn't it be a configfs file instead as that is what you are doing?

thanks,

greg k-h
