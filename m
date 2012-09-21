Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932519Ab2IUTrO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Sep 2012 15:47:14 -0400
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:59255 "EHLO
	out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757555Ab2IUTrK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Sep 2012 15:47:10 -0400
X-Sasl-enc: Lnn95jrizbPAuH+s7R7tkZ0W2MB7xw/tkfRu0KWtHyIt 1348256829
Date: Fri, 21 Sep 2012 09:49:25 -0700
From: Greg KH <greg@kroah.com>
To: Flavio Leitner <fbl@redhat.com>
Cc: linux-serial@vger.kernel.org, linux-kernel@vger.kernel.org,
        Niels de Vos <niels.devos@wincor-nixdorf.com>,
        Alan Cox <alan@linux.intel.com>
Subject: Re: [PATCH] serial: set correct baud_base for EXSYS EX-41092 Dual
 16950
Message-ID: <20120921164925.GA10494@kroah.com>
References: <1347908021-13570-1-git-send-email-fbl@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1347908021-13570-1-git-send-email-fbl@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 17, 2012 at 03:53:41PM -0300, Flavio Leitner wrote:
> Apparently the same card model has two IDs, so this patch
> complements the commit 39aced68d664291db3324d0fcf0985ab5626aac2
> adding the missing one.
> 
> Signed-off-by: Flavio Leitner <fbl@redhat.com>
> ---
>  drivers/tty/serial/8250/8250_pci.c | 7 +++++--
>  include/linux/pci_ids.h            | 3 ++-

Please read the top of the pci_ids.h file for why we don't want to add
new entries there.

Please fix that up and resend this.

thanks,

greg k-h
