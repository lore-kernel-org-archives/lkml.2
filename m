Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934186Ab3AIVU2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jan 2013 16:20:28 -0500
Received: from moutng.kundenserver.de ([212.227.126.186]:60275 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933673Ab3AIVUG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jan 2013 16:20:06 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Thierry Reding <thierry.reding@avionic-design.de>
Subject: Re: [PATCH 05/14] lib: Add I/O map cache implementation
Date: Wed, 9 Jan 2013 21:19:56 +0000
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
References: <1357764194-12677-1-git-send-email-thierry.reding@avionic-design.de> <1357764194-12677-6-git-send-email-thierry.reding@avionic-design.de>
In-Reply-To: <1357764194-12677-6-git-send-email-thierry.reding@avionic-design.de>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201301092119.57067.arnd@arndb.de>
X-Provags-ID: V02:K0:KnHr+sLDDcrqIXMQ7S2P5R9s9w0cjGLeHJ+lDqhzdNj
 Z1w6WId9mRWpoZzza9EyaegBa699ut3aV3lzNpLHnv1cE0I3tu
 qGmrztvNX1lYICRDAgqiQ1i/SdjDVhYmNYvM4u5jzyE56eIRZG
 doiQVyqPr2ze+Hz54/R9faFvT2byFGkfZXkduPH6fIaddDk96t
 STcMm1Q+dkQkrFSVEItAQSAQC7KzEpDjOkeeBSP8PYi9pmtaqh
 mv5rDQ2A++fJIUcSMnX2fRMC9tNlSvoIibxj5LAwGoggOmh6lI
 vfCBwk/hzBI22DODjXbhatk1C6WqqjrIpkkq32K+InEfIDPojk
 U2Ho2YCzqRZt7YX+1B6g=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 09 January 2013, Thierry Reding wrote:
> The I/O map cache is used to map large regions of physical memory in
> smaller chunks to avoid running out of vmalloc()/ioremap() space.
> 
> Signed-off-by: Thierry Reding <thierry.reding@avionic-design.de>

Can you explain why this is necessary and which problem it solves?
The implementation looks reasonable, but it's not clear to me if
we really need this new interface.

In what cases does it actually save ioremap space?

	Arnd
