Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754019Ab2GQBdu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jul 2012 21:33:50 -0400
Received: from mail-yx0-f174.google.com ([209.85.213.174]:33552 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750906Ab2GQBdr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jul 2012 21:33:47 -0400
Date: Mon, 16 Jul 2012 18:33:42 -0700
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Fengguang Wu <fengguang.wu@intel.com>
Cc: Alan Stern <stern@rowland.harvard.edu>,
        Cornelia Huck <cornelia.huck@de.ibm.com>,
        Kay Sievers <kay.sievers@vrfy.org>, devel@driverdev.osuosl.org,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: show_uevent() and general protection fault
Message-ID: <20120717013342.GD21914@kroah.com>
References: <20120713083140.GA19738@localhost>
 <20120713084616.GA20037@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120713084616.GA20037@localhost>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 13, 2012 at 04:46:16PM +0800, Fengguang Wu wrote:
> This is another kconfig, produced a bit different call trace, however
> also related to sysfs_read_file().

Any hint as to which file is being read?

thanks,

greg k-h
