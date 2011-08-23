Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756205Ab1HWX3F (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Aug 2011 19:29:05 -0400
Received: from out3.smtp.messagingengine.com ([66.111.4.27]:54871 "EHLO
	out3.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755531Ab1HWX2G (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Aug 2011 19:28:06 -0400
X-Sasl-enc: k3Inf7eVdc5BVzVJle3E6c+z/4Ky+IXvV4tc/vxTPDpU 1314142086
Date: Tue, 23 Aug 2011 16:08:16 -0700
From: Greg KH <greg@kroah.com>
To: "K. Y. Srinivasan" <kys@microsoft.com>
Cc: gregkh@suse.de, linux-kernel@vger.kernel.org, devel@linuxdriverproject.org,
        virtualization@lists.osdl.org, Haiyang Zhang <haiyangz@microsoft.com>
Subject: Re: [PATCH 081/117] Staging: hv: vmbus: Introduce a lock to protect
 the ext field in hv_device
Message-ID: <20110823230816.GN9641@kroah.com>
References: <1310752024-27854-1-git-send-email-kys@microsoft.com>
 <1310752065-27895-1-git-send-email-kys@microsoft.com>
 <1310752065-27895-81-git-send-email-kys@microsoft.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1310752065-27895-81-git-send-email-kys@microsoft.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 15, 2011 at 10:47:09AM -0700, K. Y. Srinivasan wrote:
> The current mechanism for handling references in broken.
> Introduce a lock to protect the ext field in hv_device.

Why would that lock ever be needed?  How can things change to this
pointer in different ways like you are thinking it could?  Doesn't the
reference counting in the device itself handle this properly?

greg k-h
