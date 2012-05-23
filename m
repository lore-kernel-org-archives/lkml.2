Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759837Ab2EWN3X (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 May 2012 09:29:23 -0400
Received: from mail-yw0-f46.google.com ([209.85.213.46]:51588 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756098Ab2EWN3V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 May 2012 09:29:21 -0400
Date: Wed, 23 May 2012 06:29:12 -0700
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Arend van Spriel <arend@broadcom.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH for-3.6] debugfs: change parameter check in
 debugfs_remove() functions
Message-ID: <20120523132912.GA23310@kroah.com>
References: <1337778788-7069-1-git-send-email-arend@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1337778788-7069-1-git-send-email-arend@broadcom.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 23, 2012 at 03:13:07PM +0200, Arend van Spriel wrote:
> The dentry parameter in debugfs_remove() and debugfs_remove_recursive()
> is checked being a NULL pointer. To make cleanup by callers easier this
> check is extended using the IS_ERR_OR_NULL macro instead because the
> debugfs_create_... functions can return a ERR_PTR() value.
> 
> Signed-off-by: Arend van Spriel <arend@broadcom.com>
> ---
> I was adding the check in driver code before calling the recursive remove,
> but considered it might be a better idea to do it in debugfs itself.

Yes, nice change, thanks.

I'll queue it up after 3.5-rc1 is out.

thanks,

greg k-h
