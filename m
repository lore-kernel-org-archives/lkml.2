Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161602Ab2COVnv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Mar 2012 17:43:51 -0400
Received: from mx1.redhat.com ([209.132.183.28]:15658 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932304Ab2COVnr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Mar 2012 17:43:47 -0400
Date: Thu, 15 Mar 2012 15:43:42 -0600
From: Pete Zaitcev <zaitcev@redhat.com>
To: Sebastian Andrzej Siewior <sebastian@breakpoint.cc>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] usb/ub: deprecate & schedule for removal the "Low
 Performance USB Block" driver
Message-ID: <20120315154342.70395b24@lembas.zaitcev.lan>
In-Reply-To: <20120315205935.GB6123@breakpoint.cc>
References: <1331758372-9851-1-git-send-email-sebastian@breakpoint.cc>
	<20120315093331.6472333e@lembas.zaitcev.lan>
	<20120315153747.GA23515@kroah.com>
	<20120315205935.GB6123@breakpoint.cc>
Organization: Red Hat, Inc.
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 15 Mar 2012 21:59:36 +0100
Sebastian Andrzej Siewior <sebastian@breakpoint.cc> wrote:

> +What:	Low Performance USB Block driver ("CONFIG_BLK_DEV_UB")
> +When:	3.6
> +Why:	This driver provides support for USB storage devices like "USB
> +	sticks". As of now, it is deactivated in Debian, Fedora and
> +        Ubuntu. All current users can switch over to usb-storage
> +        (CONFIG_USB_STORAGE) which only drawback is the additional SCSI
> +        stack.
> +Who:	Sebastian Andrzej Siewior <sebastian@breakpoint.cc>

Acked-By: Pete Zaitcev <zaitcev@redhat.com>

-- Pete
