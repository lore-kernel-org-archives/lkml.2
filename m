Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932429Ab2EGUn6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 May 2012 16:43:58 -0400
Received: from shards.monkeyblade.net ([198.137.202.13]:51302 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932189Ab2EGUn4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 May 2012 16:43:56 -0400
Date: Mon, 07 May 2012 16:43:43 -0400 (EDT)
Message-Id: <20120507.164343.229555682968117237.davem@davemloft.net>
To: yinghai@kernel.org
Cc: bhelgaas@google.com, benh@kernel.crashing.org, tony.luck@intel.com,
        x86@kernel.org, linux@dominikbrodowski.net, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, gregkh@linuxfoundation.org,
        linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arch@vger.kernel.org, sparclinux@vger.kernel.org
Subject: Re: [PATCH 16/21] sparc/PCI: register busn_res for root buses
From: David Miller <davem@davemloft.net>
In-Reply-To: <1336422606-4244-17-git-send-email-yinghai@kernel.org>
References: <1336422606-4244-1-git-send-email-yinghai@kernel.org>
	<1336422606-4244-17-git-send-email-yinghai@kernel.org>
X-Mailer: Mew version 6.5 on Emacs 24.0.95 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.6 (shards.monkeyblade.net [198.137.202.13]); Mon, 07 May 2012 13:43:47 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Yinghai Lu <yinghai@kernel.org>
Date: Mon,  7 May 2012 13:30:01 -0700

> Add the host bridge bus number aperture to the resource list.
> Like the MMIO and I/O port apertures, this is used when assigning
> resources to hot-added devices or in the case of conflicts.
> 
> [bhelgaas: write changelog]
> Signed-off-by: Yinghai Lu <yinghai@kernel.org>

Acked-by: David S. Miller <davem@davemloft.net>
