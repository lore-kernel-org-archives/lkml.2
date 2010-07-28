Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754150Ab0G1IkY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jul 2010 04:40:24 -0400
Received: from moutng.kundenserver.de ([212.227.126.186]:50177 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750876Ab0G1IkV convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jul 2010 04:40:21 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Stepan Moskovchenko <stepanm@codeaurora.org>
Subject: Re: [PATCH 1/2] arm: msm: Add System MMU support.
Date: Wed, 28 Jul 2010 10:39:44 +0200
User-Agent: KMail/1.13.5 (Linux/2.6.35-rc4-next-20100709+; KDE/4.4.90; x86_64; ; )
Cc: dwalker@codeaurora.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org
References: <1280270466-13503-1-git-send-email-stepanm@codeaurora.org>
In-Reply-To: <1280270466-13503-1-git-send-email-stepanm@codeaurora.org>
MIME-Version: 1.0
Content-Type: Text/Plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Message-Id: <201007281039.44883.arnd@arndb.de>
X-Provags-ID: V02:K0:Zk4c8yL4q8Kw4lrmHLoBNvHiDhbsXlFqMsWwQiZr8n1
 21awm+2aIi7CJWxTK4+CdwGEF6wroGRAw9ivKf0+XSTkemv0rt
 rmf4LLOl+g5BAyDCezPEuSGafJlmvmXBmYYc1wNDLW/9Hpnf3S
 g28P2edM5zJeLl88ZTO7TZKg9GA/cXtNqeX57ND4POQ3WwVJU5
 DKKg0NmIAMimBfxfEx6ww==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 28 July 2010 00:41:06 Stepan Moskovchenko wrote:
> 
> Add support for the System MMUs found on the 8x60 and 8x72
> families of Qualcomm chips. These SMMUs allow virtualization
> of the address space used by most of the multimedia cores
> on these chips.
> 

How is this different from an IOMMU?

>From a very brief look, it seems that you should be using the
existing dma-mapping APIs here instead of making up your own.

	Arnd
