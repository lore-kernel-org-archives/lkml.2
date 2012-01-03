Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751303Ab2ACBNd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jan 2012 20:13:33 -0500
Received: from out5.smtp.messagingengine.com ([66.111.4.29]:49722 "EHLO
	out5.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750990Ab2ACBNb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jan 2012 20:13:31 -0500
X-Sasl-enc: LF846h9RPBir3rfBFYnDsrunPFm4elzsptWVSVLgiRTL 1325553210
Date: Mon, 2 Jan 2012 17:12:13 -0800
From: Greg KH <greg@kroah.com>
To: Neil Horman <nhorman@tuxdriver.com>
Cc: linux-kernel@vger.kernel.org, stable@kernel.org
Subject: Re: [PATCH] firmware: Fix an oops on reading fw_priv->fw in sysfs
 loading file
Message-ID: <20120103011213.GA21956@kroah.com>
References: <1325536283-21159-1-git-send-email-nhorman@tuxdriver.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1325536283-21159-1-git-send-email-nhorman@tuxdriver.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 02, 2012 at 03:31:23PM -0500, Neil Horman wrote:
> This oops was reported recently:
> firmware_loading_store+0xf9/0x17b
> dev_attr_store+0x20/0x22
> sysfs_write_file+0x101/0x134
> vfs_write+0xac/0xf3
> sys_write+0x4a/0x6e
> system_call_fastpath+0x16/0x1b
> 
> The complete backtrace was unfortunately not captured, but details can be found
> here:
> https://bugzilla.redhat.com/show_bug.cgi?id=769920
> 
> The cause is fairly clear.

Thanks, this patch should also fix the same problem that the Motorola
developers were seeing, yet failed to create a useful patch for :)

greg k-h
