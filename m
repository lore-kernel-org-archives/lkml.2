Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754582Ab2ASIn7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jan 2012 03:43:59 -0500
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:36189 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751994Ab2ASIn5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jan 2012 03:43:57 -0500
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Message-ID: <4F17D7B7.3010609@jp.fujitsu.com>
Date: Thu, 19 Jan 2012 17:43:35 +0900
From: Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:9.0) Gecko/20111222 Thunderbird/9.0.1
MIME-Version: 1.0
To: Yinghai Lu <yinghai@kernel.org>
CC: Jesse Barnes <jbarnes@virtuousgeek.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Matthew Wilcox <matthew@wil.cx>, linux-pci@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH -v2] pciehp: Checking pci conf reading to new added device
 instead of sleep 1s
References: <1324083165-805-1-git-send-email-yinghai@kernel.org>
In-Reply-To: <1324083165-805-1-git-send-email-yinghai@kernel.org>
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2011/12/17 9:52), Yinghai Lu wrote:

<snip.>
> 
> -/*
> - * Read the config data for a PCI device, sanity-check it
> - * and fill in the dev structure...
> - */
> -static struct pci_dev *pci_scan_device(struct pci_bus *bus, int devfn)
> +bool pci_bus_read_dev_vendor_id(struct pci_bus *bus, int devfn, u32 *l,
> +				 int crs_timeout)

EXPORT_SYMBOL() for pci_bus_read_dev_vendor_id() is needed to build
pciehp as a kernel module.

Regards,
Kenji Kaneshige

