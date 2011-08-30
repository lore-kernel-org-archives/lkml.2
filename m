Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755086Ab1H3PPY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Aug 2011 11:15:24 -0400
Received: from moutng.kundenserver.de ([212.227.17.8]:56411 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755005Ab1H3PPW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Aug 2011 11:15:22 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: David Brown <davidb@codeaurora.org>
Subject: Re: [PATCH] ARM: msm: defconfigs for Qualcomm dev boards
Date: Tue, 30 Aug 2011 17:15:07 +0200
User-Agent: KMail/1.12.2 (Linux/2.6.31-22-generic; KDE/4.3.2; x86_64; ; )
Cc: Russell King <linux@arm.linux.org.uk>, linux-kernel@vger.kernel.org,
        linux-arm-msm@vger.kernel.org, linux-arm-kernel@lists.infradead.org
References: <1314664573-18432-1-git-send-email-davidb@codeaurora.org>
In-Reply-To: <1314664573-18432-1-git-send-email-davidb@codeaurora.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201108301715.07450.arnd@arndb.de>
X-Provags-ID: V02:K0:2Mo8thVOBOBtkf6DHLZUqlxAJzCmiTbvPPMQNYwNuxs
 R+6tdhAQcD2ljn7VqSW/cfpZtBiE6sNdMq1HNZm+AFpJL4oXLc
 EtI/U5yUKhodF4BcFZB1rAl/j/6XdpRA2tMCYgi18K5Iq7/ow2
 sYXsaKU9uVovmnfn6OPxcTskuQ4sajnJFtkCZSmGpEhrRzGmHg
 MsLgyQiVd76C1Iquw9x/yi59/8g24GV/8F1ACAxco1qj6/Bluk
 O0l5CZy1En2A45p0bdCgsR55yO2b2iMg857pVhsAVPH8AbYojl
 m+LK7+NnMeD9HB6q51SgNHNy16IsFjLBYH7gEl8+Yz2fV+UN+N
 Q7eppuICeEtB609cry98=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 30 August 2011, David Brown wrote:
> Add default configs for the development boards for several Qualcomm
> MSM-family chips.
> 
> Signed-off-by: David Brown <davidb@codeaurora.org>
> ---
> These are my current defconfigs for these targets.  I'd like to get
> these into next so that the targets can get build tested.  I'm not
> sure if we want to push them to mainline, since devicetree would
> theoretically eliminate the need for all of them.

I think it's reasonable to have them in mainline while the device
tree support on MSM is still incomplete, but I can also just
stick them in to a branch that I don't submit to mainline
if you prefer to have them only in linux-next.

Russell, if you want to keep the defconfig files under your
ownership, that's also fine with me. In that case:
Acked-by: Arnd Bergmann <arnd@arndb.de>

	Arnd
