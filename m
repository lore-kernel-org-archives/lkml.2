Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758102Ab3AIWDj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jan 2013 17:03:39 -0500
Received: from moutng.kundenserver.de ([212.227.17.8]:56417 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757982Ab3AIWDh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jan 2013 17:03:37 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Thierry Reding <thierry.reding@avionic-design.de>
Subject: Re: [PATCH 10/14] PCI: tegra: Move PCIe driver to drivers/pci/host
Date: Wed, 9 Jan 2013 22:03:18 +0000
User-Agent: KMail/1.12.2 (Linux/3.7.0-7-generic; KDE/4.3.2; x86_64; ; )
Cc: linux-tegra@vger.kernel.org, Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>,
        Russell King <linux@arm.linux.org.uk>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Andrew Murray <andrew.murray@arm.com>,
        Jason Gunthorpe <jgunthorpe@obsidianresearch.com>,
        Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        devicetree-discuss@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-pci@vger.kernel.org
References: <1357764194-12677-1-git-send-email-thierry.reding@avionic-design.de> <201301092122.08011.arnd@arndb.de> <20130109215815.GC13648@avionic-0098.adnet.avionic-design.de>
In-Reply-To: <20130109215815.GC13648@avionic-0098.adnet.avionic-design.de>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201301092203.18860.arnd@arndb.de>
X-Provags-ID: V02:K0:6GJdbZLj8ZqhvV4M69F5qCjaOO+iZlyNzA63NtUQDj3
 R665Wg6IkSIzFybBHtahDaqUic3nJ4DYOwJcsmi1t9IblHjPp/
 ilAw8+RZGLXXjNfP2x9/a+QY0cA/b0zOLkzmaGSIVKo7OQPKDi
 ripRSptdjEVdET8u6lwjT51mrZa/eaC5pr3BooQMz9McexJim0
 89EWqasF/BLgbOXOddNpD0S0QP5jI+zFlIl+tLHjY5tiB8xpFB
 njKc6wnO7CzNwVllXNo9Ug7/hE4YjaWBNNnbxuihCqV86XABCI
 L3/we5DPCSS6/xF//sE0TXR629qWrQ+f+6noUTnQa9tNloSzS0
 tGUuBs5wVB1huS4ATe40=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 09 January 2013, Thierry Reding wrote:
> Stephen suggested I post this as removal/addition because pretty much
> everything changed. Reviewing the individual changes would be more
> confusing than actually reviewing a new driver.
> 

Ok, fair enough.

	Arnd
