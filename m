Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751776Ab2KQMWc (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Nov 2012 07:22:32 -0500
Received: from 8bytes.org ([85.214.48.195]:55066 "EHLO mail.8bytes.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751685Ab2KQMWb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Nov 2012 07:22:31 -0500
Date: Sat, 17 Nov 2012 13:22:26 +0100
From: Joerg Roedel <joro@8bytes.org>
To: Shuah Khan <shuah.khan@hp.com>
Cc: davem@davemloft.net, kyungmin.park@samsung.com, m.szyprowski@samsung.com,
        sam@ravnborg.org, arnd@arndb.de, sparclinux@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>, shuahkhan@gmail.com
Subject: Re: [PATCH RFT] sparc: dma-mapping: support debug_dma_mapping_error
Message-ID: <20121117122226.GT25742@8bytes.org>
References: <1351211773.6851.24.camel@lorien2>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1351211773.6851.24.camel@lorien2>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-DSPAM-Result: Whitelisted
X-DSPAM-Processed: Sat Nov 17 13:22:28 2012
X-DSPAM-Confidence: 0.9982
X-DSPAM-Probability: 0.0000
X-DSPAM-Signature: 50a7818422971947418616
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 25, 2012 at 06:36:13PM -0600, Shuah Khan wrote:
> >From 9e8feb61482288c5a5dd609e0dd17c1a262a48a3 Mon Sep 17 00:00:00 2001
> From: Shuah Khan <shuahkhan@gmail.com>
> Date: Thu, 25 Oct 2012 18:31:42 -0600
> Subject: [PATCH RFT] sparc: dma-mapping: support debug_dma_mapping_error
> 
> Add support for debug_dma_mapping_error() call to avoid warning from
> debug_dma_unmap() interface when it checks for mapping error checked
> status. Without this patch, device driver failed to check map error
> warning is generated.
> 
> Signed-off-by: Shuah Khan <shuah.khan@hp.com>

Applied to dma-debug, thanks.

Btw, what about the patches for the other archs? They should depend on
the dma-debug branch too and should also be there, no?


	Joerg


