Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932771Ab0LTSPg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Dec 2010 13:15:36 -0500
Received: from moutng.kundenserver.de ([212.227.17.8]:65480 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932726Ab0LTSPf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Dec 2010 13:15:35 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 1/6 v8] ARM: Add basic architecture support for VIA/WonderMedia 85xx SoC's
Date: Mon, 20 Dec 2010 19:15:32 +0100
User-Agent: KMail/1.13.5 (Linux/2.6.37-rc6-next-20101220+; KDE/4.5.1; x86_64; ; )
Cc: Alexey Charkov <alchark@gmail.com>,
        "Russell King - ARM Linux" <linux@arm.linux.org.uk>,
        Eric Miao <eric.y.miao@gmail.com>, linux-kernel@vger.kernel.org,
        "Uwe =?iso-8859-1?q?Kleine-K=F6nig?=" 
	<u.kleine-koenig@pengutronix.de>,
        vt8500-wm8505-linux-kernel@googlegroups.com,
        Albin Tonnerre <albin.tonnerre@free-electrons.com>
References: <1289147348-31969-1-git-send-email-alchark@gmail.com> <20101111234957.GA28735@n2100.arm.linux.org.uk> <20101219174017.GA31832@alchark-u3s>
In-Reply-To: <20101219174017.GA31832@alchark-u3s>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201012201915.32851.arnd@arndb.de>
X-Provags-ID: V02:K0:Xhqj5PRokqCMus+CMg6cSp6Wo1Lx0F3QUNKQqAclz6V
 Ha3cXGDvY5SvzBpkVKa1G2dpO3guBxmakQTF2HOq7vXtIZedBf
 Ks/GJwvBo195Hn2OpcHHgenxlp1XH1P4F70DJFp/M3KE43eqLs
 rtpSndoZFuRVloR4axV0BvT1p3Z1PF1nl5hYWdyMXRS7uGKyyL
 TCgPES6UC0kjqr8RN5Q/g==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 19 December 2010 18:40:17 Alexey Charkov wrote:
> This adds support for the family of Systems-on-Chip produced initially
> by VIA and now its subsidiary WonderMedia that have recently become
> widespread in lower-end Chinese ARM-based tablets and netbooks.
> 
> Support is included for both VT8500 and WM8505. Suitable code is
> selected (if compiled in) at early initialization time by reading a
> platform-specific identification register, as current bootloaders
> do not provide any reliable machine id to the kernel.
> 
> Included are basic machine initialization files, register and
> interrupt definitions, support for the on-chip interrupt controller,
> high-precision OS timer, GPIO lines, necessary macros for early debug,
> pulse-width-modulated outputs control, as well as platform device
> configurations for the specific drivers implemented elsewhere.
> 
> Signed-off-by: Alexey Charkov <alchark@gmail.com>

Looks good to me, thanks for addressing all my previous concerns.

Reviewed-by: Arnd Bergmann <arnd@arndb.de>
