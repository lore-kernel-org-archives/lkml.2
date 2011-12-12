Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754505Ab1LLWcX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Dec 2011 17:32:23 -0500
Received: from out2.smtp.messagingengine.com ([66.111.4.26]:33632 "EHLO
	out2.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754326Ab1LLWb5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Dec 2011 17:31:57 -0500
X-Sasl-enc: ZXCigaUM/rug42EfxGBeaDJJk/fji+/yDyQdFBaoUhcx 1323729116
Date: Mon, 12 Dec 2011 14:27:12 -0800
From: Greg KH <greg@kroah.com>
To: "K. Y. Srinivasan" <kys@microsoft.com>
Cc: gregkh@suse.de, linux-kernel@vger.kernel.org, devel@linuxdriverproject.org,
        virtualization@lists.osdl.org, ohering@suse.com,
        Haiyang Zhang <haiyangz@microsoft.com>
Subject: Re: [PATCH 4/4] Drivers: hv: Support building the vmbus driver as
 part of the kernel
Message-ID: <20111212222712.GA13510@kroah.com>
References: <1323710931-29616-1-git-send-email-kys@microsoft.com>
 <1323710959-29655-1-git-send-email-kys@microsoft.com>
 <1323710959-29655-4-git-send-email-kys@microsoft.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1323710959-29655-4-git-send-email-kys@microsoft.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 12, 2011 at 09:29:19AM -0800, K. Y. Srinivasan wrote:
> Support building the vmbus driver as part of the kernel. 
> 
> Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>
> Signed-off-by: Haiyang Zhang <haiyangz@microsoft.com>

This was already applied to my tree, I don't know why you missed it...

greg k-h
