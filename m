Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759070Ab2JZTB6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Oct 2012 15:01:58 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:50146 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759037Ab2JZTB5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Oct 2012 15:01:57 -0400
Date: Fri, 26 Oct 2012 15:01:53 -0400 (EDT)
Message-Id: <20121026.150153.1335892148865957561.davem@davemloft.net>
To: shuah.khan@hp.com
Cc: kyungmin.park@samsung.com, arnd@arndb.de, m.szyprowski@samsung.com,
        sam@ravnborg.org, sparclinux@vger.kernel.org,
        linux-kernel@vger.kernel.org, shuahkhan@gmail.com
Subject: Re: [PATCH RFT RESEND linux-next] sparc: dma-mapping: support
 debug_dma_mapping_error
From: David Miller <davem@davemloft.net>
In-Reply-To: <1351267989.4013.20.camel@lorien2>
References: <1351211773.6851.24.camel@lorien2>
	<1351211909.6851.26.camel@lorien2>
	<1351267989.4013.20.camel@lorien2>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Shuah Khan <shuah.khan@hp.com>
Date: Fri, 26 Oct 2012 10:13:09 -0600

> Add support for debug_dma_mapping_error() call to avoid warning from
> debug_dma_unmap() interface when it checks for mapping error checked
> status. Without this patch, device driver failed to check map error
> warning is generated.
> 
> Signed-off-by: Shuah Khan <shuah.khan@hp.com>

Why are you resending this?

When you resend patches, you have to give a reason.  Did the patch
change?  Are you updating the CC: list of the patch posting? Are
you correcting something else?
