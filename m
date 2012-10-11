Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758209Ab2JKJQk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Oct 2012 05:16:40 -0400
Received: from moutng.kundenserver.de ([212.227.126.171]:65441 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757760Ab2JKJQd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Oct 2012 05:16:33 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 6/6] mfd: Differentiate between u8500 and u9540 TCDM address mapping
Date: Thu, 11 Oct 2012 09:16:07 +0000
User-Agent: KMail/1.12.2 (Linux/3.5.0; KDE/4.3.2; x86_64; ; )
Cc: Lee Jones <lee.jones@linaro.org>, linux-kernel@vger.kernel.org,
        linus.walleij@stericsson.com
References: <1349882335-6786-1-git-send-email-lee.jones@linaro.org> <201210101834.40749.arnd@arndb.de> <20121011085951.GU9707@gmail.com>
In-Reply-To: <20121011085951.GU9707@gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201210110916.08159.arnd@arndb.de>
X-Provags-ID: V02:K0:4MHO6j8Nc9igNuNN//k/k+nX168R2hlXACqce5ztsKE
 gET/UPFgFHqWdL3d4OPGie2y/bZZD+F0YwzPG4U2Bcw94AQK2a
 HKhGFQ6jZ21nuZPxhz7uVJi8YtWHeNaTsxP4kfhlA+Yraorv8k
 fKzPFs3XgbtWS3mZ/Jy5gCZ3Blsd8P+Hl3vZowkq/9Sop08DWU
 NmuyEL9QM9OyAmYbncFX+rd67E0VuHXk27APDjSw24/mvYKvne
 lpnph3uGMdhc9r0j8rvBm9Z4GDdchCP4/lkl/toq2dlfvf4UlE
 avXAyh00NLL/soMwaDmUpThrcA7q6FA0LYrQl1uDJHNMBHa2wg
 lZ5A5kfxlh/xzhsp6Aqk=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 11 October 2012, Lee Jones wrote:
> From what I understand, this code has to be called before Device
> Tree kicks in. Actually, this code is mearly a stand-in until Loic
> has finished with the PRCMU re-vamp. Once that's complete, this
> stuff will be passed from init_IRQ(), which is invoked directly in
> start_kernel().

Ok, fair enough.

	Arnd
