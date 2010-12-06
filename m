Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752758Ab0LFRJ7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Dec 2010 12:09:59 -0500
Received: from kroah.org ([198.145.64.141]:40125 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751755Ab0LFRJ6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Dec 2010 12:09:58 -0500
Date: Mon, 6 Dec 2010 09:09:42 -0800
From: Greg KH <greg@kroah.com>
To: Luben Tuikov <ltuikov@yahoo.com>
Cc: linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org
Subject: Re: [PATCH] [USB] UASP: USB Attached SCSI (UAS) protocol driver
Message-ID: <20101206170942.GA2947@kroah.com>
References: <254705.78010.qm@web31805.mail.mud.yahoo.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <254705.78010.qm@web31805.mail.mud.yahoo.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 06, 2010 at 09:05:11AM -0800, Luben Tuikov wrote:
> This driver allows you to connect to UAS devices
> and use them as SCSI devices.

We already have this support in the kernel tree, why do you want and
need another driver that does the same exact thing?

thanks,

greg k-h
