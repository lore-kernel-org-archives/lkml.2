Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757704Ab2BBXdS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Feb 2012 18:33:18 -0500
Received: from out4-smtp.messagingengine.com ([66.111.4.28]:46236 "EHLO
	out4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757679Ab2BBXdR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Feb 2012 18:33:17 -0500
X-Sasl-enc: /oAkMmkZWz2n1yeGqImRwBd6zXo+ZyTE4bSmld0np5f+ 1328225596
Date: Thu, 2 Feb 2012 15:31:45 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: "K. Y. Srinivasan" <kys@microsoft.com>
Cc: gregkh@suse.de, linux-kernel@vger.kernel.org, devel@linuxdriverproject.org,
        virtualization@lists.osdl.org, ohering@suse.com, zbr@ioremap.net
Subject: Re: [PATCH 0000/0006] drivers: hv
Message-ID: <20120202233145.GA17516@kroah.com>
References: <1327708522-26914-1-git-send-email-kys@microsoft.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1327708522-26914-1-git-send-email-kys@microsoft.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 27, 2012 at 03:55:22PM -0800, K. Y. Srinivasan wrote:
> 
> This patch-set does some cleanup of the KVP component. Also included is a
> patch that will remove artificial limitation on the number of VCPUs that
> can be assigned to the Linux guest on Hyper-V.

I have applied the first 2, please fix patch 3, and resend the rest.

thanks,

greg k-h
