Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932240Ab1FAWQ4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Jun 2011 18:16:56 -0400
Received: from out3.smtp.messagingengine.com ([66.111.4.27]:54761 "EHLO
	out3.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755135Ab1FAWQy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Jun 2011 18:16:54 -0400
X-Sasl-enc: BVIbtFJvTrY+QuufKz6FFUzku4nC+rCrV/t8pMacenpu 1306966613
Date: Thu, 2 Jun 2011 07:17:13 +0900
From: Greg KH <greg@kroah.com>
To: Maarten Lankhorst <m.b.lankhorst@gmail.com>
Cc: Sarah Sharp <sarah.a.sharp@linux.intel.com>, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org, stable@kernel.org
Subject: Re: [stable] [PATCH 1/2] xhci: Add defines for hardcoded slot states
Message-ID: <20110601221713.GA17429@kroah.com>
References: <1306963670-6344-1-git-send-email-m.b.lankhorst@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1306963670-6344-1-git-send-email-m.b.lankhorst@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 01, 2011 at 11:27:49PM +0200, Maarten Lankhorst wrote:
> Signed-off-by: Maarten Lankhorst <m.b.lankhorst@gmail.com>
> ---
>  drivers/usb/host/xhci-dbg.c |    8 ++++----
>  drivers/usb/host/xhci.h     |    5 +++++
>  2 files changed, 9 insertions(+), 4 deletions(-)


<formletter>

This is not the correct way to submit patches for inclusion in the
stable kernel tree.  Please read Documentation/stable_kernel_rules.txt
for how to do this properly.

</formletter>
