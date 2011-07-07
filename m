Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756721Ab1GGOtU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jul 2011 10:49:20 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:37296 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756332Ab1GGOtS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jul 2011 10:49:18 -0400
Date: Thu, 7 Jul 2011 15:49:21 +0100
From: Catalin Marinas <catalin.marinas@arm.com>
To: Heechul Yun <heechul@illinois.edu>
Cc: Russell King - ARM Linux <linux@arm.linux.org.uk>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        saeed.bishara@gmail.com
Subject: Re: [PATCHv2] remove unnecessary cache flush on v6 copypage
Message-ID: <20110707144921.GA15429@1n450.cable.virginmedia.net>
References: <20110707143019.GA16819@heechul-desktop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110707143019.GA16819@heechul-desktop>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 07, 2011 at 09:30:19AM -0500, Heechul Yun wrote:
> ARM: mm: remove unnecessary cache flush on v6 copypage

Just move this line in the subject and remove it from the body.

> Originally introduced to maintain coherency between icache and dcache
> in v6 nonaliasing mode. This is now handled by __sync_icache_dcache since
> c0177800, therefore unneceary in this function.  

Minor typo - "unnecessary".

Thanks.

-- 
Catalin
