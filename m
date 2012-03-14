Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761495Ab2CNVHg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Mar 2012 17:07:36 -0400
Received: from mail-yx0-f174.google.com ([209.85.213.174]:49975 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758550Ab2CNVHe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Mar 2012 17:07:34 -0400
Date: Wed, 14 Mar 2012 14:07:29 -0700
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Sebastian Andrzej Siewior <sebastian@breakpoint.cc>
Cc: linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        Pete Zaitcev <zaitcev@redhat.com>, Jens Axboe <jaxboe@fusionio.com>
Subject: Re: [PATCH] usb/ub: deprecate & schedule for removal the "Low
 Performance USB Block" driver
Message-ID: <20120314210729.GA11887@kroah.com>
References: <1331758372-9851-1-git-send-email-sebastian@breakpoint.cc>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1331758372-9851-1-git-send-email-sebastian@breakpoint.cc>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 14, 2012 at 09:52:51PM +0100, Sebastian Andrzej Siewior wrote:
> Deprecate this driver. All devices which can be handled by this driver
> can also be handled by the usb-storage driver.
> 
> Cc: Pete Zaitcev <zaitcev@redhat.com>

I need an ack here from Pete before I can accept this.

