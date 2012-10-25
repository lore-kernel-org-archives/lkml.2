Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759199Ab2JYCQq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Oct 2012 22:16:46 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:38898 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759122Ab2JYCQn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Oct 2012 22:16:43 -0400
Date: Wed, 24 Oct 2012 19:17:19 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Dave Jones <davej@redhat.com>
Subject: Re: linux-next: manual merge of the usb tree with the usb.current
 tree
Message-ID: <20121025021719.GB1603@kroah.com>
References: <20121025130545.5755af42c5573e2253866913@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121025130545.5755af42c5573e2253866913@canb.auug.org.au>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 25, 2012 at 01:05:45PM +1100, Stephen Rothwell wrote:
> Hi Greg,
> 
> Today's linux-next merge of the usb tree got a conflict in
> drivers/usb/misc/ezusb.c between commit 197ef5ef37d9 ("USB: Add missing
> license tag to ezusb driver") from the usb.current tree and commitc
> 30186e51e53 ("USB: ezusb: unexport some functions that aren't being
> used") from the usb tree.
> 
> I fixed it up (see below) and can carry the fix as necessary (no action
> is required).

Looks good to me, thanks.

greg k-h
