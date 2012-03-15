Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030880Ab2COPdj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Mar 2012 11:33:39 -0400
Received: from mx1.redhat.com ([209.132.183.28]:6725 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932411Ab2COPdh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Mar 2012 11:33:37 -0400
Date: Thu, 15 Mar 2012 09:33:31 -0600
From: Pete Zaitcev <zaitcev@redhat.com>
To: Sebastian Andrzej Siewior <sebastian@breakpoint.cc>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] usb/ub: deprecate & schedule for removal the "Low
 Performance USB Block" driver
Message-ID: <20120315093331.6472333e@lembas.zaitcev.lan>
In-Reply-To: <1331758372-9851-1-git-send-email-sebastian@breakpoint.cc>
References: <1331758372-9851-1-git-send-email-sebastian@breakpoint.cc>
Organization: Red Hat, Inc.
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 14 Mar 2012 21:52:51 +0100
Sebastian Andrzej Siewior <sebastian@breakpoint.cc> wrote:

> +What:	Low Performance USB Block driver ("CONFIG_BLK_DEV_UB")
> +When:	3.6

ACK

> +	does not use libusual which holds various workarounds for
> +	certain buggy devices.

Although the above is false, and ub actually started libusual,
I don't mind. It's a transient notice anyway. Once ub is gone,
libusual can be folded back into usb-storage.

-- Pete
