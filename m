Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755603Ab2K1Quc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Nov 2012 11:50:32 -0500
Received: from mail.kernel.org ([198.145.19.201]:53715 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754919Ab2K1Qu3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Nov 2012 11:50:29 -0500
Date: Wed, 28 Nov 2012 08:50:24 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: Eli Billauer <eli.billauer@gmail.com>
Cc: linux-kernel@vger.kernel.org, arnd@arndb.de
Subject: Re: [PATCH 1/2] pci_ids: Added FPGA-related entries
Message-ID: <20121128165024.GA31314@kroah.com>
References: <1354117293-13632-1-git-send-email-eli.billauer@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1354117293-13632-1-git-send-email-eli.billauer@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 28, 2012 at 05:41:32PM +0200, Eli Billauer wrote:
> These entries are referred to by the Xillybus driver.
> 
> Signed-off-by: Eli Billauer <eli.billauer@gmail.com>
> ---
>  include/linux/pci_ids.h |    6 ++++++

Please read the top of this file for why you shouldn't be adding these
device ids to that file.

Care to redo these two patches please?

thanks,

greg k-h
