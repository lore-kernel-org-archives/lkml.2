Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756344Ab1HWXax (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Aug 2011 19:30:53 -0400
Received: from out3.smtp.messagingengine.com ([66.111.4.27]:54580 "EHLO
	out3.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755968Ab1HWX2E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Aug 2011 19:28:04 -0400
X-Sasl-enc: XwRiwe6vyB1HorwjTCUA+w7zrk8dSL7sCcSFWaF2IEJU 1314142083
Date: Tue, 23 Aug 2011 16:03:08 -0700
From: Greg KH <greg@kroah.com>
To: "K. Y. Srinivasan" <kys@microsoft.com>
Cc: gregkh@suse.de, linux-kernel@vger.kernel.org, devel@linuxdriverproject.org,
        virtualization@lists.osdl.org, Haiyang Zhang <haiyangz@microsoft.com>
Subject: Re: [PATCH 037/117] Staging: hv: vmbus: Get rid of the  device_id
 attribute
Message-ID: <20110823230308.GL9641@kroah.com>
References: <1310752024-27854-1-git-send-email-kys@microsoft.com>
 <1310752065-27895-1-git-send-email-kys@microsoft.com>
 <1310752065-27895-37-git-send-email-kys@microsoft.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1310752065-27895-37-git-send-email-kys@microsoft.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 15, 2011 at 10:46:25AM -0700, K. Y. Srinivasan wrote:
> The guid based instance data is not very useful. There is enough information
> to identify the device. Get rid of this attribute.

But userspace probably wants to see this at times, don't remove it,
someone is going to need it, especially as this is how the driver/device
is bound together.

why delete it?

greg k-h
