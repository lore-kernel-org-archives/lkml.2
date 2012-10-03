Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751906Ab2JCT2O (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Oct 2012 15:28:14 -0400
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:40841 "EHLO
	out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751160Ab2JCT2M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Oct 2012 15:28:12 -0400
X-Sasl-enc: r/K3sg5BB1xkmL3dq0Is4YYL8+3lOtfdQkB7h79HsQjF 1349292490
Date: Wed, 3 Oct 2012 12:28:09 -0700
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Yinghai Lu <yinghai@kernel.org>
Cc: Bjorn Helgaas <bhelgaas@google.com>, linux-pci@vger.kernel.org,
        linux-kernel@vger.kernel.org, Don Dutile <ddutile@redhat.com>,
        yuvalmin@broadcom.com, bhutchings@solarflare.com,
        gregory.v.rose@intel.com, davem@davemloft.net--no-chain-reply-to
Subject: Re: [PATCH 2/5] PCI, sys: Use is_visable() with boot_vga attribute
 for pci_dev
Message-ID: <20121003192809.GA9224@kroah.com>
References: <506C3B11.9010009@redhat.com>
 <1349286695-26713-1-git-send-email-yinghai@kernel.org>
 <1349286695-26713-3-git-send-email-yinghai@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1349286695-26713-3-git-send-email-yinghai@kernel.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 03, 2012 at 10:51:32AM -0700, Yinghai Lu wrote:
> That could let pci_create_sysfs_dev_files more simple.
> 
> also fix possible fix memleak during removing path.
> 
> Signed-off-by: Yinghai Lu <yinghai@kernel.org>

This, combined with the 1/5 patch, looks great, thanks for doing this.

Acked-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

