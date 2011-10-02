Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754710Ab1JBVVD (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Oct 2011 17:21:03 -0400
Received: from moutng.kundenserver.de ([212.227.126.186]:57488 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753195Ab1JBVU5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Oct 2011 17:20:57 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: linux-arm-kernel@lists.infradead.org
Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>,
        alsa-devel@alsa-project.org,
        Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>,
        linux-kernel@vger.kernel.org, Paul Mundt <lethal@linux-sh.org>,
        Liam Girdwood <lrg@ti.com>
Subject: Re: [PATCH 4/6] ASoC: sh: use correct __iomem annotations
Date: Sun, 02 Oct 2011 23:20:07 +0200
Message-ID: <3365303.m9SmYBJMXM@wuerfel>
User-Agent: KMail/4.7.1 (Linux/3.0.0-rc1nosema+; KDE/4.7.1; x86_64; ; )
In-Reply-To: <20111002205008.GB4506@opensource.wolfsonmicro.com>
References: <1317587284-2776-1-git-send-email-arnd@arndb.de> <1317587284-2776-5-git-send-email-arnd@arndb.de> <20111002205008.GB4506@opensource.wolfsonmicro.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:RPywg8B8znN5KGjVVx0nIfH7NZ85+vlLooQZPy/MwkJ
 28/tknkZONKgMFB/DTsItknMZV76BEGVbe2DHzVhll6P7DQ/jB
 0uKeJWEqTl961EuwpIQWwsrYQQuaD5ATr+nMoj4sQ69dLg4OSc
 6MWzvs4Gz/hG/sVqiwRo2eothUbqxJWfxeO9MYzIOtgbjlHy2H
 oLwwWsg8LLN/sxj1lZbKgRy7vPg2sdulguiZRvHTJWpUwNU67q
 Gqz6Ga3h+/mzeiinHkfcN7n6oZAs1Mm/1rPxL79emZBnbq90H2
 Zw4lSLyfrgnn5wKJWxX1qdyIL8lYgTfqs2BwODz1xVuQkO8LTu
 wmEp4saze1clpfHS+iOM=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 02 October 2011 21:50:09 Mark Brown wrote:
> On Sun, Oct 02, 2011 at 10:28:02PM +0200, Arnd Bergmann wrote:
> > This removes a few unnecessary type casts and avoids
> > sparse warnings.
> 
> Applied, thanks.

Thank you very much for the realtime feedback and patch applying.

	Arnd
