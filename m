Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754154Ab2GWPO2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jul 2012 11:14:28 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:56518 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750969Ab2GWPO1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jul 2012 11:14:27 -0400
Date: Mon, 23 Jul 2012 08:14:22 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Anton Blanchard <anton@samba.org>
Cc: kay@vrfy.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Enable devtmpfs by default
Message-ID: <20120723151422.GA19236@kroah.com>
References: <20120723115414.724e0046@kryten>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120723115414.724e0046@kryten>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 23, 2012 at 11:54:14AM +1000, Anton Blanchard wrote:
> 
> udev now requires CONFIG_DEVTMPFS so make it default to y.
> 
> I noticed this when booting a ppc64 pseries_defconfig on Fedora 17
> and it paniced because it couldn't mount the root device.

All the world isn't Fedora :)

See Linus's recent thread about distro configs, that's the best solution
for something like this.

greg k-h
