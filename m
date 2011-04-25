Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751618Ab1DYFgE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Apr 2011 01:36:04 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:56933
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751258Ab1DYFgC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Apr 2011 01:36:02 -0400
Date: Sun, 24 Apr 2011 22:35:29 -0700 (PDT)
Message-Id: <20110424.223529.226784817.davem@davemloft.net>
To: greg@kroah.com
Cc: netdev@vger.kernel.org, oliver@neukum.name, gregkh@suse.de,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        hselasky@c2i.net
Subject: Re: [PATCH] cdc_ncm: fix short packet issue on some devices
From: David Miller <davem@davemloft.net>
In-Reply-To: <20110424235930.GA11109@kroah.com>
References: <20110424235930.GA11109@kroah.com>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Greg KH <greg@kroah.com>
Date: Sun, 24 Apr 2011 16:59:30 -0700

> From: Hans Petter Selasky <hselasky@c2i.net>
> 
> The default maximum transmit length for NCM USB frames should be so
> that a short packet happens at the end if the device supports a length
> greater than the defined maximum. This is achieved by adding 4 bytes
> to the maximum length so that the existing logic can fit a short
> packet there.
> 
> Signed-off-by: Hans Petter Selasky <hselasky@c2i.net>
> Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

Applied, thanks Greg.
