Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757928Ab1GAWl0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Jul 2011 18:41:26 -0400
Received: from out3.smtp.messagingengine.com ([66.111.4.27]:50127 "EHLO
	out3.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757598Ab1GAWlZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Jul 2011 18:41:25 -0400
X-Sasl-enc: IwsMimUvQAf5dw1AKXWJNUalRPBM3UM7yOkkDK68CCuA 1309560084
Date: Fri, 1 Jul 2011 15:32:09 -0700
From: Greg KH <greg@kroah.com>
To: Alexander Stein <alexander.stein@systec-electronic.com>
Cc: Tomoya MORINAGA <tomoya-linux@dsn.okisemi.com>,
        Alan Cox <alan@linux.intel.com>, linux-serial@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] pch_uart: Add MSI support
Message-ID: <20110701223209.GA9581@kroah.com>
References: <4E02857C.1010304@dsn.okisemi.com>
 <1308812405-5245-1-git-send-email-alexander.stein@systec-electronic.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1308812405-5245-1-git-send-email-alexander.stein@systec-electronic.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 23, 2011 at 09:00:05AM +0200, Alexander Stein wrote:
> Signed-off-by: Alexander Stein <alexander.stein@systec-electronic.com>
> ---
> Changes in v2:
> * msi_enabled is stored in pci_dev already, skip it in our code

This doesn't apply to my tree, what kernel tree is it against?

greg k-h
