Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754167Ab1EWI2F (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 May 2011 04:28:05 -0400
Received: from smtprelay06.ispgateway.de ([80.67.31.101]:33837 "EHLO
	smtprelay06.ispgateway.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754114Ab1EWI2B (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 May 2011 04:28:01 -0400
Message-ID: <4DDA1B18.3080201@ladisch.de>
Date: Mon, 23 May 2011 10:30:16 +0200
From: Clemens Ladisch <clemens@ladisch.de>
User-Agent: Thunderbird 2.0.0.24 (Windows/20100228)
MIME-Version: 1.0
To: Leon Woestenberg <leon.woestenberg@gmail.com>
CC: Takashi Iwai <tiwai@suse.de>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        linux-pci@vger.kernel.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: Re: mmap() implementation for pci_alloc_consistent() memory?
References: <BANLkTi==cinS1bZc_ARRbnYT3YD+FQr8gA@mail.gmail.com>	<20110519145921.GE9854@dumpdata.com>	<4DD53E2B.2090002@ladisch.de>	<BANLkTinO1xR4XTN2B325pKCpJ3AjC9YidA@mail.gmail.com>	<4DD60F57.8030000@ladisch.de>	<s5htycp6b25.wl%tiwai@suse.de> <BANLkTi=P6WP-+BiqEwCRTxaNTqNHT988wA@mail.gmail.com>
In-Reply-To: <BANLkTi=P6WP-+BiqEwCRTxaNTqNHT988wA@mail.gmail.com>
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Df-Sender: linux-kernel@cl.domainfactory-kunde.de
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Leon Woestenberg wrote:
> Having dma_mmap_coherent() there is good for one or two archs, but how
> can we built portable drivers if the others arch's are still missing?

Easy: Resolve all issues, implement it for all the other arches, and add
it to the official DMA API.

> How would dma_mmap_coherent() look like on x86?

X86 and some others are always coherent; just use vm_insert_page() or
remap_page_range().


Regards,
Clemens
