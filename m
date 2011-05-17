Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756769Ab1EQWcI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 May 2011 18:32:08 -0400
Received: from out4.smtp.messagingengine.com ([66.111.4.28]:45880 "EHLO
	out4.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756695Ab1EQWcG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 May 2011 18:32:06 -0400
X-Sasl-enc: Txe6oeOPN/PccTjebmyGh0mJUtqMI3emGBDKiXt0i/3g 1305671525
Date: Tue, 17 May 2011 15:31:55 -0700
From: Greg KH <greg@kroah.com>
To: "K. Y. Srinivasan" <kys@microsoft.com>
Cc: gregkh@suse.de, linux-kernel@vger.kernel.org, devel@linuxdriverproject.org,
        virtualization@lists.osdl.org
Subject: Re: [PATCH 2/2] Connector: Correctly set the error code in case of
 success when dispatching receive callbacks
Message-ID: <20110517223155.GC15741@kroah.com>
References: <1305671138-19443-1-git-send-email-kys@microsoft.com>
 <1305671138-19443-2-git-send-email-kys@microsoft.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1305671138-19443-2-git-send-email-kys@microsoft.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 17, 2011 at 03:25:38PM -0700, K. Y. Srinivasan wrote:
> The recent changes to the connector code introduced this bug where even
> when a callback was invoked, we would return an error resulting in
> double freeing of the skb. This patch fixes this bug.

By "recent" what do you mean?  Is this something that is in the .39
kernel?  Do you have a git commit id that caused this?

Or is this due to changes that are queued up for the .40 merge window?

thanks,

greg k-h
