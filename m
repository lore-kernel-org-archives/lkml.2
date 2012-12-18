Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754699Ab2LRLcQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Dec 2012 06:32:16 -0500
Received: from mga09.intel.com ([134.134.136.24]:44979 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754006Ab2LRLcO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Dec 2012 06:32:14 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,308,1355126400"; 
   d="scan'208";a="258883155"
Date: Tue, 18 Dec 2012 11:34:59 +0000
From: Alan Cox <alan@linux.intel.com>
To: Laxman Dewangan <ldewangan@nvidia.com>
Cc: <gregkh@linuxfoundation.org>, <jslaby@suse.cz>,
        <grant.likely@secretlab.ca>, <rob.herring@calxeda.com>,
        <devicetree-discuss@lists.ozlabs.org>, <linux-doc@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <linux-serial@vger.kernel.org>,
        <linux-tegra@vger.kernel.org>, <swarren@wwwdotorg.org>,
        <wmb@firmworks.com>
Subject: Re: [PATCH V2] serial: tegra: add serial driver
Message-ID: <20121218113459.5ce6f4a5@bob.linux.org.uk>
In-Reply-To: <1355813993-24867-1-git-send-email-ldewangan@nvidia.com>
References: <1355813993-24867-1-git-send-email-ldewangan@nvidia.com>
Organization: Intel
X-Mailer: Claws Mail 3.8.1 (GTK+ 2.24.13; x86_64-redhat-linux-gnu)
Organisation: Intel Corporation UK Ltd, registered no. 1134945 (England),
 Registered office Pipers Way, Swindon, SN3 1RJ
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 18 Dec 2012 12:29:53 +0530
Laxman Dewangan <ldewangan@nvidia.com> wrote:

> Nvidia's Tegra has multiple uart controller which supports:
> - APB dma based controller fifo read/write.
> - End Of Data interrupt in incoming data to know whether end
>   of frame achieve or not.
> - Hw controlled RTS and CTS flow control to reduce SW overhead.
> 
> Add serial driver to use all above feature.
> 
> Signed-off-by: Laxman Dewangan <ldewangan@nvidia.com>

Acked-by: Alan Cox <alan@linux.intel.com>
