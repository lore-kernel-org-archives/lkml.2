Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752221Ab2FLD2S (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jun 2012 23:28:18 -0400
Received: from linux-sh.org ([111.68.239.195]:49881 "EHLO linux-sh.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751175Ab2FLD2Q (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jun 2012 23:28:16 -0400
Date: Tue, 12 Jun 2012 12:27:14 +0900
From: Paul Mundt <lethal@linux-sh.org>
To: T Makphaibulchoke <tmac@hp.com>
Cc: linux@arm.linux.org.uk, schwidefsky@de.ibm.com, heiko.carstens@de.ibm.com,
        linux390@de.ibm.com, hpa@zytor.com, tglx@linutronix.de,
        mingo@redhat.com, x86@kernel.org, kaloz@openwrt.org,
        nicolas.pitre@linaro.org, jj@chaosbits.net, matt.fleming@intel.com,
        lasse.collin@tukaani.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, linux-s390@vger.kernel.org,
        linux-sh@vger.kernel.org
Subject: Re: [PATCH v2] lib/decompress_unxz.c: removing all memory helper
 functions
Message-ID: <20120612032713.GI10170@linux-sh.org>
References: <1339470307-28223-1-git-send-email-tmac@hp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1339470307-28223-1-git-send-email-tmac@hp.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 11, 2012 at 09:05:07PM -0600, T Makphaibulchoke wrote:
> Removing the memset function and adding the new source file include to
> arch/sh/boot/compressed/misc.c
> 
..

> Signed-off-by: T. Makphaibulchoke <tmac@hp.com>
> 
Acked-by: Paul Mundt <lethal@linux-sh.org>
