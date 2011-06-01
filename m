Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932402Ab1FAWRA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Jun 2011 18:17:00 -0400
Received: from out3.smtp.messagingengine.com ([66.111.4.27]:42762 "EHLO
	out3.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932284Ab1FAWQ5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Jun 2011 18:16:57 -0400
X-Sasl-enc: sA0aSFXgYZKV6OQCGySFwyByc839LVSSo6xk572qL/Ne 1306966616
Date: Thu, 2 Jun 2011 07:17:22 +0900
From: Greg KH <greg@kroah.com>
To: Maarten Lankhorst <m.b.lankhorst@gmail.com>
Cc: Sarah Sharp <sarah.a.sharp@linux.intel.com>, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org, stable@kernel.org
Subject: Re: [stable] [PATCH 2/2] xhci: Do not issue device reset when device
 is not setup
Message-ID: <20110601221722.GB17429@kroah.com>
References: <1306963670-6344-1-git-send-email-m.b.lankhorst@gmail.com>
 <1306963670-6344-2-git-send-email-m.b.lankhorst@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1306963670-6344-2-git-send-email-m.b.lankhorst@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 01, 2011 at 11:27:50PM +0200, Maarten Lankhorst wrote:
> Xhci controllers respond to this by returning an error. Instead of
> issuing a command that will fail, just return.
> 
> This fixes the xhci driver not working on asrock P67 Pro/Extreme boards.
> 
> Signed-off-by: Maarten Lankhorst <m.b.lankhorst@gmail.com>
> ---
>  drivers/usb/host/xhci.c |    7 +++++++
>  1 files changed, 7 insertions(+), 0 deletions(-)


<formletter>

This is not the correct way to submit patches for inclusion in the
stable kernel tree.  Please read Documentation/stable_kernel_rules.txt
for how to do this properly.

</formletter>
