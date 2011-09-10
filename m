Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934117Ab1IJVhT (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Sep 2011 17:37:19 -0400
Received: from moutng.kundenserver.de ([212.227.17.9]:61246 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933810Ab1IJVhS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Sep 2011 17:37:18 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: David Brown <davidb@codeaurora.org>
Subject: Re: [GIT PULL] msm: initial devicetree support
Date: Sat, 10 Sep 2011 23:37:08 +0200
User-Agent: KMail/1.12.2 (Linux/2.6.35-22-generic; KDE/4.3.2; x86_64; ; )
Cc: Nicolas Pitre <nicolas.pitre@linaro.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Russell King <rmk@arm.linux.org.uk>, linux-arm-msm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
References: <20110830225139.GA7093@huya.qualcomm.com>
In-Reply-To: <20110830225139.GA7093@huya.qualcomm.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201109102337.09057.arnd@arndb.de>
X-Provags-ID: V02:K0:o2piFHcrnu85opeVJ33OB+vEOWI63ys1eHpO4GwxNH6
 PF5VtDztK5wec7dQMdKa70pbcNdy0ey7pEzSSKGMyArGBNH1Ux
 BoIM7wzwpc+qnI81CkdtDkFMEA8TWJbYFEdNm0ik8SAwr1DtEW
 0gp8xvhW04OtjFgpBxG+dQrecB22i4oBp+keutJwYIMoPcCViC
 PCphylJxaGbtMBsbOxEQGdX7IGqnFH5xq6TTOX54YRq3MtiSv0
 KmGp/dlcsC2NfpQ5LxRH6a90nmI/xSk7vcjbTt1EOiFQZHj2g1
 IiAqHNS6jdOQ4TxVsnwsVVpL/K4p4AHnxSAabyFX1yArJRPZQ6
 bb7rlbnr5ML3H7Vl4iUg=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 31 August 2011, David Brown wrote:
> The following changes since commit c6a389f123b9f68d605bb7e0f9b32ec1e3e14132:
> 
>   Linux 3.1-rc4 (2011-08-28 21:16:01 -0700)
> 
> are available in the git repository at:
>   git://codeaurora.org/quic/kernel/davidb/linux-msm.git msm-dt
> 
> David Brown (3):
>       msm_serial: Use relative resources for iomem
>       msm_serial: Add devicetree support
>       ARM: msm: Add devicetree support for msm8660-surf


Pulled into the next/dt branch of the temporary arm-soc.git on git.linaro.org.

Thanks!

	Arnd
