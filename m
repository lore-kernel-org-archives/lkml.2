Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755574Ab2BVCch (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Feb 2012 21:32:37 -0500
Received: from mail-qw0-f53.google.com ([209.85.216.53]:47034 "EHLO
	mail-qw0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753736Ab2BVCcf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Feb 2012 21:32:35 -0500
MIME-Version: 1.0
In-Reply-To: <012701ccf108$67a1ef80$36e5ce80$%kim@samsung.com>
References: <20120222124915.9414928ca50d8b181820c733@canb.auug.org.au>
	<012701ccf108$67a1ef80$36e5ce80$%kim@samsung.com>
Date: Wed, 22 Feb 2012 11:32:34 +0900
X-Google-Sender-Auth: gtcik-KgVSfs65JSMWdbaFdZcCo
Message-ID: <CAH9JG2UUznpqWyO-obQVTvTovBe1xBXNrFjSgnu9DH6xdecToA@mail.gmail.com>
Subject: Re: linux-next: manual merge of the mmc tree with the s5p tree
From: Kyungmin Park <kyungmin.park@samsung.com>
To: Kukjin Kim <kgene.kim@samsung.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, Chris Ball <cjb@laptop.org>,
        linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jaehoon Chung <jh80.chung@samsung.com>,
        Thomas Abraham <thomas.abraham@linaro.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I'm really disappointed with samsung sdhci merge. we sent several
patches, one month or two month ago. e.g., simple patch adding caps2
overrides feature.

To resolve these issue fianlly. can you move all mmc related things to
include/linux/platform_da
ta/ and controlled by mmc maintainer?

I hope no more dependency with arch codes and drivers codes.

Thank you,
Kyungmin Park

On 2/22/12, Kukjin Kim <kgene.kim@samsung.com> wrote:
> Stephen Rothwell wrote:
>>
>> Hi Chris,
>>
> Hi Stephen,
>
>> Today's linux-next merge of the mmc tree got a conflict in
>> drivers/mmc/host/sdhci-s3c.c between commit bd0955ed6b1b ("mmc:
>> sdhci-s3c: add platform data for the second capability") from the s5p
>> tree and commit 7880741a0625 ("mmc: sdhci-s3c: derive transfer width host
>> capability from max_width in platform data") from the mmc tree.
>>
>> Just context changes.  I fixed it up (see below) and can carry the fix as
>> necessary.
>
> Look ok to me, and let me carry following when it is required.
>
> Thanks.
>
> Best regards,
> Kgene.
> --
> Kukjin Kim <kgene.kim@samsung.com>, Senior Engineer,
> SW Solution Development Team, Samsung Electronics Co., Ltd.
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>
