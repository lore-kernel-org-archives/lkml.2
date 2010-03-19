Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752354Ab0CSUwW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Mar 2010 16:52:22 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:46230 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751595Ab0CSUwU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Mar 2010 16:52:20 -0400
Date: Fri, 19 Mar 2010 13:52:09 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Florian Fainelli <florian@openwrt.org>
Cc: linux-kernel@vger.kernel.org, Samuel Ortiz <sameo@linux.intel.com>,
       Wim Van Sebroeck <wim@iguana.be>, Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH 2/4 v2] MFD: add support for the RDC321x southbridge
Message-Id: <20100319135209.435131cb.akpm@linux-foundation.org>
In-Reply-To: <201003110942.09251.florian@openwrt.org>
References: <201003110942.09251.florian@openwrt.org>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.9; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 11 Mar 2010 09:42:09 +0100
Florian Fainelli <florian@openwrt.org> wrote:

> +static struct pci_device_id rdc321x_sb_table[] = {
> +	{ PCI_DEVICE(PCI_VENDOR_ID_RDC, PCI_DEVICE_ID_RDC_R6030) },
> +	{}
> +};

should be const, methinks.
