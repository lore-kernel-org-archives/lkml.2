Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756786Ab1FGUtL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Jun 2011 16:49:11 -0400
Received: from out1.smtp.messagingengine.com ([66.111.4.25]:41697 "EHLO
	out1.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754325Ab1FGUtJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Jun 2011 16:49:09 -0400
X-Sasl-enc: RJaYYTcW4Kulf1T4riyXF7WMuVBxXMhNAxjhsq5WLgxd 1307479747
Date: Tue, 7 Jun 2011 13:44:12 -0700
From: Greg KH <greg@kroah.com>
To: "K. Y. Srinivasan" <kys@microsoft.com>
Cc: gregkh@suse.de, linux-kernel@vger.kernel.org, devel@linuxdriverproject.org,
        virtualization@lists.osdl.org, Haiyang Zhang <haiyangz@microsoft.com>,
        Abhishek Kane <v-abkane@microsoft.com>
Subject: Re: [PATCH 15/49] Staging: hv: vmbus: Make vmbus an acpi bus driver
Message-ID: <20110607204412.GA16429@kroah.com>
References: <1307400540-13193-1-git-send-email-kys@microsoft.com>
 <1307400613-13234-1-git-send-email-kys@microsoft.com>
 <1307400613-13234-15-git-send-email-kys@microsoft.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1307400613-13234-15-git-send-email-kys@microsoft.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 06, 2011 at 03:49:39PM -0700, K. Y. Srinivasan wrote:
> Now, make the vmbus driver an ACPI bus driver.

Why an ACPI bus driver and not a PCI one?  Is that what this really is?
For some reason, I thought it was a PCI device that we hooked our bus
off of, is that not true?

greg k-h
