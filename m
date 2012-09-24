Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755214Ab2IXHYW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Sep 2012 03:24:22 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:39893 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753103Ab2IXHYU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Sep 2012 03:24:20 -0400
X-AuditID: cbfee61b-b7f2b6d000000f14-2b-50600aa3602d
Message-id: <50600A9E.5080009@samsung.com>
Date: Mon, 24 Sep 2012 16:24:14 +0900
From: Chanwoo Choi <cw00.choi@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:10.0.2) Gecko/20120216
 Thunderbird/10.0.2
MIME-version: 1.0
To: Peter Huewe <peterhuewe@gmx.de>
Cc: MyungJoo Ham <myungjoo.ham@samsung.com>, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org, Greg KH <gregkh@linuxfoundation.org>
Subject: Re: [PATCH 1/2] extcon: Unregister compat class at module unload to
 fix oops
References: <1348278070-22202-1-git-send-email-peterhuewe@gmx.de>
In-reply-to: <1348278070-22202-1-git-send-email-peterhuewe@gmx.de>
Content-type: text/plain; charset=ISO-8859-1
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrLLMWRmVeSWpSXmKPExsVy+t9jAd3FXAkBBisuiVhc3jWHzWLBxkeM
	DkwenzfJBTBGcdmkpOZklqUW6dslcGU0L5nDVNDNXtH8dQl7A+Mr1i5GTg4JAROJjTvvQ9li
	EhfurWfrYuTiEBJYxChxeMtzZgjnJaPE5JlHmboYOTh4BbQk9n+SA2lgEVCVOLxsGzOIzQYS
	fnGDDaREVCBC4lc/B0iYV0BQ4sfkeywgtoiAssT+V/vYQUYyC3QySpxa1cYIkhAWCJdYe/sj
	O4gtJOAose7JW3aQOZwCThKvLjOBhJkFdCT2t05jg7DlJTavecs8gVFgFpIVs5CUzUJStoCR
	eRWjaGpBckFxUnqukV5xYm5xaV66XnJ+7iZGcCA+k97BuKrB4hCjAAejEg/vhjPxAUKsiWXF
	lbmHGCU4mJVEeCOeAYV4UxIrq1KL8uOLSnNSiw8xSnOwKInzCn8KDBASSE8sSc1OTS1ILYLJ
	MnFwSjUwJou88nlW8W1l/fJ/ez+9X+4fZfDJdFnG3GCnogee0XcXtQUvnvhjufWhJtXb11ee
	XG93OG/d3uCgP9yh77d860tflDXpWOu2FWb2t6bN8n40b+HD9GOb3z38OGPNnIwP8pEcDEcS
	1Q645MlEr9ySErHo2077S3duv9cJv+VbIlHp2B+/68TLlm9KLMUZiYZazEXFiQCz/7L7QAIA	AA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[...]

> 
> ---[ end trace dd512cc03fe1c369 ]---
> FATAL: Error inserting extcon_class
> (/lib/modules/3.6.0-rc6-00178-g811315f/kernel/drivers/extcon/extcon_class.ko):
> Cannot allocate memory
> 
> This patch fixes this.
> 
> Cc: stable@vger.kernel.org
> Signed-off-by: Peter Huewe <peterhuewe@gmx.de>
> ---


Applied, thank you

There was issue, but I fixed them up:

>  drivers/extcon/extcon_class.c |    3 +++
>  1 files changed, 3 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/extcon/extcon_class.c b/drivers/extcon/extcon_class.c


extcon_class.c was renamed to comply with the standard naming.
If you will write patch about extcon, please work patch based on below
git repository.

You will check it after some hours on below git repository.
-
http://git.infradead.org/users/kmpark/linux-samsung/shortlog/refs/heads/extcon-for-next

Thanks,
Chanwoo Choi

