Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758026Ab1FVOJM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Jun 2011 10:09:12 -0400
Received: from moutng.kundenserver.de ([212.227.126.186]:61177 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753411Ab1FVOJL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Jun 2011 10:09:11 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: David Miller <davem@davemloft.net>
Subject: Re: comedi doesn't build on several architectures
Date: Wed, 22 Jun 2011 16:08:59 +0200
User-Agent: KMail/1.12.2 (Linux/2.6.31-22-generic; KDE/4.3.2; x86_64; ; )
Cc: greg@kroah.com, linux-kernel@vger.kernel.org
References: <20110621.194925.1313933193955144936.davem@davemloft.net>
In-Reply-To: <20110621.194925.1313933193955144936.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201106221608.59978.arnd@arndb.de>
X-Provags-ID: V02:K0:mDtIjH6jkB9kp1KW/PmfOyPhOw8hE5toB2Z5QnbZSah
 ROo8b8s+4D7AgTWB/Ui/PiC2tkrymcj4HLpzZoeu/BjLxxElMm
 puYMW9SYLPwU4jnMNByIXKjHgdf8eKjKOn0Rs0TOO9pGuszF+8
 hQC/YhdTufuXei/+Ob6Q/RHCoWT2/z/hlGp6E9V2vNd1lzoUH0
 L1nRKQqrDd+yHayogW3bw==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 22 June 2011, David Miller wrote:
> It depends upon PAGE_KERNEL_NOCACHE which only a handful of
> platforms define.
> 
> Really, enabling staging in Linus's tree with all this build fallout
> was not the wisest.  It's blowing up all of my allmodconfig test
> builds now.

Is staging supposed to compile on non-x86? I've done a lot of
ARM randconfig builds, but I just disabled all of staging using
KCONFIG_ALLCONFIG because I didn't see the point.

	Arnd
