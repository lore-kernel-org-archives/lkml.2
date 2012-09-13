Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757438Ab2IMKgl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Sep 2012 06:36:41 -0400
Received: from moutng.kundenserver.de ([212.227.17.9]:57823 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757385Ab2IMKgh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Sep 2012 06:36:37 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: David Brown <davidb@codeaurora.org>
Subject: Re: [PATCH 1/2] ARM: SoC: convert MSM SMP to SoC descriptor
Date: Thu, 13 Sep 2012 08:47:19 +0000
User-Agent: KMail/1.12.2 (Linux/3.5.0; KDE/4.3.2; x86_64; ; )
Cc: Marc Zyngier <marc.zyngier@arm.com>, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org
References: <1347461906-13527-7-git-send-email-arnd@arndb.de> <1347490900-8409-1-git-send-email-davidb@codeaurora.org>
In-Reply-To: <1347490900-8409-1-git-send-email-davidb@codeaurora.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201209130847.20087.arnd@arndb.de>
X-Provags-ID: V02:K0:wm328bdLhIs/htR8UUaQ6/J4OKP4tPXoChxm9/UdoN+
 BF3cQeB6VUZT6KEwrH/vXJXxm7a72RK/KTiSbF0d9HRyxQFanm
 G4xEeguJn06rdYP9Oez2PiD6Ia2a6gjPismeNK+wuQ9oTlO3pI
 S3nuDf/I6dAa/omQ0cO2qQd21mN2q3M6ZFtRVSAxYaJCLps54c
 ee8jrg2nKovHwnfLmsqZ7a21fLebFeTt2f5126D3QSarVI3flC
 d7h4NEDOUA0KXedJreFIISPpqDrQtnlTrTD5umFQ7GHZuG633h
 RQDTOgTW2Mid8f3bOv+INfIyIm10reT5n5nr2vRwYSHDy5XXNP
 a+lvmGTSb3N0+geIhMss=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 12 September 2012, David Brown wrote:
> 
> From: Marc Zyngier <marc.zyngier@arm.com>
> 
> Convert MSM SMP platforms to use the SoC descriptor to provide
> their SMP and CPU hotplug operations.
> 
> Cc: David Brown <davidb@codeaurora.org>
> Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> ---
> This is an adaptation of this change on top of the msm-for-3.7 tree I
> recently sent out a pull request for.  The only real change is to
> resolve the conflicts with the simplified board files.

Not sure what I'm supposed to do with this patch, it doesn't apply
unless I rebase all of the SMP patches on top of your msm-for-3.7 branch,
which would be rather odd.

I'll make sure the branches merge fine and then apply your patch 2/2
on top of the merge, ok?

	Arnd

