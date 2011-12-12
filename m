Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754439Ab1LLWcB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Dec 2011 17:32:01 -0500
Received: from out2.smtp.messagingengine.com ([66.111.4.26]:47390 "EHLO
	out2.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754353Ab1LLWb7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Dec 2011 17:31:59 -0500
X-Sasl-enc: CNpLdX2Eryyagecwq7Py9fH1nCmF510ieNJp8vS7gUs/ 1323729118
Date: Mon, 12 Dec 2011 14:28:01 -0800
From: Greg KH <greg@kroah.com>
To: "K. Y. Srinivasan" <kys@microsoft.com>
Cc: gregkh@suse.de, linux-kernel@vger.kernel.org, devel@linuxdriverproject.org,
        virtualization@lists.osdl.org, ohering@suse.com
Subject: Re: [PATCH 0000/0004] Drivers: hv: Fixes
Message-ID: <20111212222801.GA16054@kroah.com>
References: <1323710931-29616-1-git-send-email-kys@microsoft.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1323710931-29616-1-git-send-email-kys@microsoft.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 12, 2011 at 09:28:51AM -0800, K. Y. Srinivasan wrote:
> Some fixes to the vmbus driver:
> 
> 	1. Fix a memory leak in a failure path.
> 
> 	2. Make vmbus driver unloadable.
> 
> 	3. Get rid of an unnecessary check in hv_init()
> 	   in preparation for supporting kexec().
> 
> 	4. Make it possible to build the vmbus driver as part of the
> 	   kernel. This patch was submitted earlier, but seems to have been 
> 	   lost.

No, it was not lost, it was applied to my driver-core-next tree a while
ago.  Because of this, I had to hand-edit patch 2 above and skip patch 4
here.

greg k-h
