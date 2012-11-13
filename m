Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754586Ab2KMJzX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Nov 2012 04:55:23 -0500
Received: from nm19-vm0.bullet.mail.ukl.yahoo.com ([217.146.183.113]:43135
	"EHLO nm19-vm0.bullet.mail.ukl.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753173Ab2KMJzU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Nov 2012 04:55:20 -0500
X-Yahoo-Newman-Id: 99745.41435.bm@smtp114.mail.ukl.yahoo.com
X-Yahoo-Newman-Property: ymail-3
X-YMail-OSG: 3xRuklwVM1nTxi06xKQ0DLQHdzTJajnAUOJDtpkAliA5ez2
 Yd487sAmDd7KlPIgRROJBTXy5xYIl4sEAW6pruWcUMkz3i84.WRWakMYcBTL
 JECQ3zB5oY6KJXrzUdkGZqFLcYksHQOUvgzwjhCZ0t.w4CaqihXWk59tCVM9
 EGh.eR4FTpbywNT.ORE0GymOEHb.HZPqlu8_f5jM4_.tdWkTRBWU0UN8Ng.v
 hrcWXRrQ9akW7zjs4DPuKvNu60kikhwBflCIY5eoh_JcY.4BzCdxK4W.CP1U
 YcsYd_U.YFpo530wHGDjGdUX5HjX8dDQiQ9BHY65w8AkyHu1R_8dq5niflWG
 JJUe_1hryo_Q4T8t6lgscnJ.HE8BthECRc_AkAgTM5BYoxOyXvq28R8Achxq
 CBFioWdM03tFIXNvI54u1mSsuzyMJSRKWEr3CC_puA6mUn9oVOOO_bfgcrBz
 4ixnREFi1pGZZb7x1NNwY
X-Yahoo-SMTP: tW.h3tiswBBMXO2coYcbPigGD5Lt6zY_.Zc-
From: Marek Lindner <lindner_marek@yahoo.de>
To: b.a.t.m.a.n@lists.open-mesh.org
Subject: Re: [B.A.T.M.A.N.] [PATCH v4 9/9] net: batman-adv: use per_cpu_add helper
Date: Tue, 13 Nov 2012 17:55:12 +0800
User-Agent: KMail/1.13.7 (Linux/3.2.0-4-amd64; KDE/4.8.4; x86_64; ; )
Cc: Shan Wei <shanwei88@gmail.com>, siwu@hrz.tu-chemnitz.de,
        ordex@autistici.org, David Miller <davem@davemloft.net>,
        NetDev <netdev@vger.kernel.org>,
        "Kernel-Maillist" <linux-kernel@vger.kernel.org>,
        Christoph Lameter <cl@linux.com>
References: <50A1A816.3070900@gmail.com>
In-Reply-To: <50A1A816.3070900@gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201211131755.13299.lindner_marek@yahoo.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, November 13, 2012 09:53:26 Shan Wei wrote:
> From: Shan Wei <davidshan@tencent.com>
> 
> this_cpu_add is an atomic operation.
> and be more faster than per_cpu_ptr operation.
> 
> Signed-off-by: Shan Wei <davidshan@tencent.com>
> Reviewed-by: Christoph Lameter <cl@linux.com>
> ---
> v4: no changes vs v3.
> ---
>  net/batman-adv/main.h |    4 +---
>  1 files changed, 1 insertions(+), 3 deletions(-)

Applied in our tree (revision f8b19e1). We will pass along this patch through 
our standard workflow. No need to resend this patch in the future.

Thanks,
Marek
