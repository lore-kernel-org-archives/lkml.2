Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756306Ab1JYCki (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Oct 2011 22:40:38 -0400
Received: from out5.smtp.messagingengine.com ([66.111.4.29]:53326 "EHLO
	out5.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756197Ab1JYCkf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Oct 2011 22:40:35 -0400
X-Sasl-enc: xvdIBEcH7Cv74bXKXKSU8ACFndNXL6h4E3gJhSt5shso 1319510434
Date: Tue, 25 Oct 2011 04:27:17 +0200
From: Greg KH <greg@kroah.com>
To: "K. Y. Srinivasan" <kys@microsoft.com>
Cc: gregkh@suse.de, linux-kernel@vger.kernel.org, devel@linuxdriverproject.org,
        virtualization@lists.osdl.org, ohering@suse.com,
        Haiyang Zhang <haiyangz@microsoft.com>
Subject: Re: [PATCH 1/1] Staging: hv: vmbus: Support building the vmbus
 driver as part of the kernel
Message-ID: <20111025022717.GA32457@kroah.com>
References: <1319488265-26936-1-git-send-email-kys@microsoft.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1319488265-26936-1-git-send-email-kys@microsoft.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 24, 2011 at 01:31:05PM -0700, K. Y. Srinivasan wrote:
> Modify the way we initialize the vmbus driver so that all the hyper-v drivers
> can be linked with the kernel and still ensure that the vmbus driver
> is fully initialized before the drivers that depend upon the vmbus 
> driver attempt to initialize.
> 
> Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>
> Signed-off-by: Haiyang Zhang <haiyangz@microsoft.com>

Any reason you sent this out twice?  Was there a difference between the
two versions that I missed?

greg k-h
