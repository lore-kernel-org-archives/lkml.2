Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753236Ab1FIGrQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Jun 2011 02:47:16 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:47435 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751855Ab1FIGrO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Jun 2011 02:47:14 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-type:content-transfer-encoding:message-id;
        b=F7W8OyLEBLOvy8zYEHRGT0naUmbYoEz9FVyiN14Fs/5fz6ooYFYyn3n+IS36cCOnO0
         nN5fxY+xOB6WlE2HsLS3DFCFs2wodvCD36QrTs9z+hwUDbu+XryJSCWJQK0gMXo41mI2
         aSGpPsGXgdWPdKTHOPDkIM7ytLIaBlvtln3SA=
From: Vasily Khoruzhick <anarsoul@gmail.com>
To: linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 4/4] This patch add configuraton for ok2440 development board.
Date: Thu, 9 Jun 2011 09:46:39 +0300
User-Agent: KMail/1.13.7 (Linux/2.6.39-gentoo-anarsoul; KDE/4.6.3; i686; ; )
Cc: Wu DaoGuang <wdgvip@gmail.com>, ben-linux@fluff.org,
        linux@arm.linux.org.uk, linux-kernel@vger.kernel.org
References: <1307581402-3808-1-git-send-email-wdgvip@gmail.com> <1307581402-3808-4-git-send-email-wdgvip@gmail.com>
In-Reply-To: <1307581402-3808-4-git-send-email-wdgvip@gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201106090946.40337.anarsoul@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 09 June 2011 04:03:22 Wu DaoGuang wrote:
> Add the default configuration for ok2440 development board.

Please, no huge defconfigs. Modify s3c2410_defconfig instead.

> Signed-off-by: Wu DaoGuang <wdgvip@gmail.com>
> ---
>  arch/arm/configs/ok2440_defconfig | 2821
> +++++++++++++++++++++++++++++++++++++ 1 files changed, 2821 insertions(+),
> 0 deletions(-)
>  create mode 100644 arch/arm/configs/ok2440_defconfig
