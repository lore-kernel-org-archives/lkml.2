Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754163Ab0HWPkS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Aug 2010 11:40:18 -0400
Received: from cantor.suse.de ([195.135.220.2]:44953 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754115Ab0HWPkQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Aug 2010 11:40:16 -0400
Date: Mon, 23 Aug 2010 08:36:34 -0700
From: Greg KH <gregkh@suse.de>
To: Joey Lee <jlee@novell.com>
Cc: mjg59@srcf.ucam.org, trenn@suse.de, linux-kernel@vger.kernel.org,
        platform-driver-x86@vger.kernel.org, Dennis.Jansen@web.de
Subject: Re: [PATCH] Support MSI Poulsbo netbook U110/U115
Message-ID: <20100823153634.GB18649@suse.de>
References: <4C72EE25020000230001F28F@novprvlin0050.provo.novell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4C72EE25020000230001F28F@novprvlin0050.provo.novell.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 23, 2010 at 05:54:45AM -0600, Joey Lee wrote:
> I readed the following mail loop for Poulsbo drm driver:
> 
> http://sourceforge.net/mailarchive/message.php?msg_name=49C3CB88.2000202%40shipmail.org
> 
> Looks like GregKH is working on extract 2D video driver for
> Poulsbo/Morrestown. We will need the 2D driver then add the opregion
> support in Poulsbo 2D dirver like the Ironlake.

That was over a year ago and I quickly gave up on this effort as Intel
was not going to support it at all, sorry.

greg k -h
