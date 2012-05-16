Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760416Ab2EPSvB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 May 2012 14:51:01 -0400
Received: from moutng.kundenserver.de ([212.227.126.186]:56652 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755159Ab2EPSu7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 May 2012 14:50:59 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Nicolas Ferre <nicolas.ferre@atmel.com>
Subject: Re: [PATCH] ARM: at91: Add ADC driver to at91sam9260/at91sam9g20 dtsi files
Date: Wed, 16 May 2012 18:50:54 +0000
User-Agent: KMail/1.12.2 (Linux/3.4.0-rc3; KDE/4.3.2; x86_64; ; )
Cc: gregkh@linuxfoundation.org, sfr@canb.auug.org.au,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        plagnioj@jcrosoft.com, maxime.ripard@free-electrons.com,
        olof@lixom.net, linux-next@vger.kernel.org
References: <4FB3B1F3.6080102@atmel.com> <1337182626-13033-1-git-send-email-nicolas.ferre@atmel.com>
In-Reply-To: <1337182626-13033-1-git-send-email-nicolas.ferre@atmel.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201205161850.54765.arnd@arndb.de>
X-Provags-ID: V02:K0:pi6EZqSGn3DueMMNNP6b97zcD5f69WtiEN2AoyXWpRp
 UzI4vZLyIz6aWqSY0GoFrAG1wShaHEFLNIZ8vHIXnK9NG0FReI
 FcqI3zUV8/cHGOP8p8qF3TRpDanePna/mojhS2ennenfOayjjb
 Qy7W9l/6zZ7EBTUCgwIcFyzMcRtESQF7MGGkjz6uD34D+dOwSO
 y/34cOLbKRGFQSp4gssNqc8ReYqBtm/mvHFH2OyxJQtA/T7Egk
 1OhS3GwyA6ZFjOSmgqjNFn3zP5JcmP4amLwnJm7kDuSNgBEqoZ
 23QJm8gy3vVSJhh/GqEKdTGZaC3zwf7tB1ToLFMNjvD6sdWtt/
 bRYW9TrUksi+StJuWEdo=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 16 May 2012, Nicolas Ferre wrote:
> Now that the bulk of at91sam9g20-related nodes are located in at91sam9260.dtsi,
> we have to re-create the path to this ADC node for SoC specific parts.
> 
> Signed-off-by: Nicolas Ferre <nicolas.ferre@atmel.com>

Should we apply this patch in arm-soc so that Greg can drop the hunk that
no longer applies?

	Arnd
