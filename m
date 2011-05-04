Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753216Ab1EDNMu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 May 2011 09:12:50 -0400
Received: from moutng.kundenserver.de ([212.227.126.186]:61400 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752272Ab1EDNMt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 May 2011 09:12:49 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Michal Simek <monstr@monstr.eu>
Subject: Re: [PATCH v4] uio/pdrv_genirq: Add OF support
Date: Wed, 4 May 2011 15:12:45 +0200
User-Agent: KMail/1.12.2 (Linux/2.6.37; KDE/4.3.2; x86_64; ; )
Cc: devicetree-discuss@lists.ozlabs.org, grant.likely@secretlab.ca,
        john.williams@petalogix.com, linux-kernel@vger.kernel.org,
        hjk@hansjkoch.de, w.sang@pengutronix.de
References: <1304319115-32745-1-git-send-email-monstr@monstr.eu>
In-Reply-To: <1304319115-32745-1-git-send-email-monstr@monstr.eu>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201105041512.45294.arnd@arndb.de>
X-Provags-ID: V02:K0:45/Ddly27xKJjQRwlIesE4yNVGawxDAa9hYPBcURkwV
 cObe1kJ7Z92DddyBqNDrxxGGhehD/SogQg5SuCSZDG/J3iuF/J
 gKIE5BMfCoV3TMlks/F8B4jjFZgKfNP92adpaD8/9/8xVTGprw
 n+v8g41vWEWSq95ag9MzMUfpifQ+ZkssVp5Rpn9Il5wQQFVAo/
 V78XExtfxbd0RjWXGCpiA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 02 May 2011, Michal Simek wrote:
> Adding OF binding to genirq.
> Version string is setup to the "devicetree".
> 
> Compatible string is not setup for now but you can add your
> custom compatible string to uio_of_genirq_match structure.
> 
> For example with "vendor,device" compatible string:
> static const struct of_device_id __devinitconst uio_of_genirq_match[] = {
>         { .compatible = "vendor,device", },
>         { /* empty for now */ },
> };
> 
> Signed-off-by: Michal Simek <monstr@monstr.eu>

Reviewed-by: Arnd Bergmann <arnd@arndb.de>
