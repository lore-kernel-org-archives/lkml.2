Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934743Ab2JXNVi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Oct 2012 09:21:38 -0400
Received: from moutng.kundenserver.de ([212.227.126.186]:62699 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932343Ab2JXNVh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Oct 2012 09:21:37 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Lee Jones <lee.jones@linaro.org>
Subject: Re: [PATCH 1/1] mmc: Standardise capability type
Date: Wed, 24 Oct 2012 13:21:26 +0000
User-Agent: KMail/1.12.2 (Linux/3.5.0; KDE/4.3.2; x86_64; ; )
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linus.walleij@stericsson.com, Chris Ball <cjb@laptop.org>,
        linux-mmc@vger.kernel.org
References: <1351084664-30526-1-git-send-email-lee.jones@linaro.org>
In-Reply-To: <1351084664-30526-1-git-send-email-lee.jones@linaro.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201210241321.26878.arnd@arndb.de>
X-Provags-ID: V02:K0:kUpr1iUAvAgPVhzjz8xPjm1OVdo5PIrA7rJ4m5hKdkY
 5Sco2lMy2gFQYLbuxTuaO+dCkTnbaGriyabAwFsVQlPw19kMAZ
 NyZva6DKxzE0HA27Ds5CQX5iMWqr/9Y5h0oa4wY1bZ1MK5psmM
 Rjk4UNu/xovo6SagosVzS3V1G8NINkxvyOfwgTgMN+vR/v2LL6
 QNAz0bFGt7zeGeZO+7RyUW/m0U2uC4vemgqTYNK1j/54xiC5De
 AS8vRD739DGudEBsHsWvbSxCaHkOXzX9PH3meZGBMF0ZSfSu2L
 4kXS2Di464cmSD7WptP6uQjXb8VWqxT5gBDuCSTE2vRckVng0/
 wzR8xCGZrU3Io/MPFke0=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 24 October 2012, Lee Jones wrote:
> 
> There are discrepancies with regards to how MMC capabilities
> are carried throughout the subsystem. Let's standardise them
> to elevate any confusion.
> 
> Cc: Chris Ball <cjb@laptop.org>
> Cc: linux-mmc@vger.kernel.org
> Signed-off-by: Lee Jones <lee.jones@linaro.org>

Why make it "unsigned long" then? I think that adds to the
confusion because it's sometimes 32 bits and sometimes 64 bits,
depending on the CPU. Since it's a bitmask, I would suggest
using u32 to make the size explicit.

	Arnd
