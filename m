Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753164Ab2GZVpE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jul 2012 17:45:04 -0400
Received: from moutng.kundenserver.de ([212.227.126.187]:57537 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753170Ab2GZVo7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jul 2012 17:44:59 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Yaniv Gardi <ygardi@codeaurora.org>
Subject: Re: [PATCH v8 2/2] mmc: card: Adding support for sanitize in eMMC 4.5
Date: Thu, 26 Jul 2012 13:27:49 +0000
User-Agent: KMail/1.12.2 (Linux/3.5.0; KDE/4.3.2; x86_64; ; )
Cc: linux-mmc@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        open list <linux-kernel@vger.kernel.org>
References: <1343208766-8046-1-git-send-email-ygardi@codeaurora.org> <1343208766-8046-3-git-send-email-ygardi@codeaurora.org>
In-Reply-To: <1343208766-8046-3-git-send-email-ygardi@codeaurora.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201207261327.49781.arnd@arndb.de>
X-Provags-ID: V02:K0:NAgf0uDackCHRaWtT+OO+SGUcuDwQ1qipLOz+FCZQKD
 6BviQIT9xD6hMaalGJSx7tlLxThT6QHzslluv/EYTsOE3nyA19
 /kfLo2huSJ5kjudQANuu4ZJO4I9Zk+xFW7egLX6sc3M9GpvJwq
 0LLLQvwH2aJF1kOKsZVWWnzZ4mtahJ5zP8lNHVi+bUq1CMEwp7
 t1oXmM/WIFSbNGGVA8RuBDWcOcmtR3kkbNm8AcXwvXcAf1bofq
 ybKffFPriE54dVuYYS/xHG46gpDahOwFnbB5FriPWlX/o2Ops8
 DzUCrbGyO7VDvmJ7UU4Pnbh1zmz8bZ3yKgMr+5vsUQHi5lCgEB
 pHhZLKffn8UhtH+VEKyE=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 25 July 2012, Yaniv Gardi wrote:
> This feature delete the unmap memory region of the eMMC card,
> by writing to a specific register in the EXT_CSD
> unmap region is the memory region that were previously deleted
> (by erase, trim or discard operation)
> 
> Signed-off-by: Yaniv Gardi <ygardi@codeaurora.org>

This looks like it will only work for eMMC-4.5 but not for SD-3.01, which
offers the same funcitonality in the form of the "start recording" option
to CMD20. Is there any reason why you would want to implement one but
not the other?

	Arnd

