Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965785Ab2B1QWF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Feb 2012 11:22:05 -0500
Received: from out5-smtp.messagingengine.com ([66.111.4.29]:34298 "EHLO
	out5-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756248Ab2B1QWD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Feb 2012 11:22:03 -0500
X-Sasl-enc: IrXSLj9tZzwJEOpzAhzxY0c81ZnD6AiJrZviva1V+FBb 1330446121
Date: Tue, 28 Feb 2012 08:12:49 -0800
From: Greg KH <greg@kroah.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Yinghai Lu <yinghai@kernel.org>,
        Jesse Barnes <jbarnes@virtuousgeek.org>
Subject: Re: linux-next: manual merge of the driver-core tree with the pci
 tree
Message-ID: <20120228161249.GA19433@kroah.com>
References: <20120228142909.48fa1eea6980eaffa27abfdc@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120228142909.48fa1eea6980eaffa27abfdc@canb.auug.org.au>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 28, 2012 at 02:29:09PM +1100, Stephen Rothwell wrote:
> Hi Greg,
> 
> Today's linux-next merge of the driver-core tree got a conflict in
> include/linux/pci.h between commit 6754b9e9c335 ("PCI: Rename
> pci_remove_behind_bridge to pci_stop_and_remove_behind_bridge") from the
> pci tree and commit aad4f4000cec ("PCI: Add helper macro for
> pci_register_driver boilerplate") from the driver-core tree.
> 
> Just context changes.  I fixed it up (see below) and can carry the fix as
> necessary.

Looks good to me, thanks for the fixup.

greg k-h
