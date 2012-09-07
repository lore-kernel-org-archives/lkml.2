Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752221Ab2IGPxZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Sep 2012 11:53:25 -0400
Received: from g5t0006.atlanta.hp.com ([15.192.0.43]:27609 "EHLO
	g5t0006.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750838Ab2IGPxY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Sep 2012 11:53:24 -0400
Message-ID: <1347033200.2603.19.camel@lorien2>
Subject: [RFC] DMA mapping error check analysis
From: Shuah Khan <shuah.khan@hp.com>
Reply-To: shuah.khan@hp.com
To: fujita.tomonori@lab.ntt.co.jp, akpm@linux-foundation.org,
        paul.gortmaker@windriver.com, bhelgaas@google.com, amwang@redhat.com,
        joerg.roedel@amd.com, paul.gortmaker@windriver.com, kubakici@wp.pl,
        stern@rowland.harvard.edu, dan.carpenter@oracle.com,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Cc: LKML <linux-kernel@vger.kernel.org>, devel@linuxdriverproject.org,
        shuahkhan@gmail.com
Date: Fri, 07 Sep 2012 09:53:20 -0600
In-Reply-To: <1346595257.4377.5.camel@lorien2>
References: <1346595257.4377.5.camel@lorien2>
Organization: ISS-Linux
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I analyzed all calls to dma_map_single() and dma_map_page() in the
kernel, to see if callers check for mapping errors, before using the
returned address.

The goal of this analysis is to find drivers that currently do not 
check dma mapping errors, and fix them.

I documented the results of this analysis:

http://linuxdriverproject.org/mediawiki/index.php/DMA_Mapping_Error_Analysis

Please review and give me feedback on the analysis and the proposed
next steps.

Thanks,
-- Shuah

