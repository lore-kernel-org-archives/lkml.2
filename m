Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755566Ab2FKPbz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jun 2012 11:31:55 -0400
Received: from moutng.kundenserver.de ([212.227.17.9]:61950 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752221Ab2FKPbx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jun 2012 11:31:53 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Lee Jones <lee.jones@linaro.org>
Subject: Re: [PATCH 01/14] rtc: ab8500-rtc: IRQF_ONESHOT when requesting a threaded IRQ
Date: Mon, 11 Jun 2012 15:31:20 +0000
User-Agent: KMail/1.12.2 (Linux/3.5.0-rc1+; KDE/4.3.2; x86_64; ; )
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linus.walleij@stericsson.com, grant.likely@secretlab.ca,
        Alessandro Zummo <a.zummo@towertech.it>, rtc-linux@googlegroups.com
References: <1339428307-3850-1-git-send-email-lee.jones@linaro.org> <1339428307-3850-2-git-send-email-lee.jones@linaro.org>
In-Reply-To: <1339428307-3850-2-git-send-email-lee.jones@linaro.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201206111531.20468.arnd@arndb.de>
X-Provags-ID: V02:K0:WOCPVyu6CTrRdIc7XFFs+dWoLXDQB9wbv5YyajqUn3S
 00w8u/5QRRmtqsmC/GoZiraL7F0wnKlEjEZFNGc3CSqZyFvcof
 VU99cKqZwpKT5/JGO6bJ8MzX/GlXax4pSf6z/v4L+VabeYjJJQ
 GuGfNLnSAkCQrCwJvZkUccsQSXa9uqH5FS9Yo/XhaMK6jkqbbe
 c3elYuTD+9354u1bpL8z1b9Mhpx4knX2h4Gfu33JOjku8il9b5
 suaDJVoxi2ISf8MweWlo59AdiFXaMJPhnKKPmKaPtxaIvSyP9E
 o83bvcb9fhZrPm7pQhrpr/TOah1tKs57hGGPOhtp1hBG4JNbwl
 N4Eifd7DcoqyrXUIAUd8=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 11 June 2012, Lee Jones wrote:
> The kernel now forces IRQs to be ONESHOT if no IRQ handler is passed.
> 
> Cc: Alessandro Zummo <a.zummo@towertech.it>
> Cc: rtc-linux@googlegroups.com
> Signed-off-by: Lee Jones <lee.jones@linaro.org>

Isn't this a bug fix that should be applied to the stable kernels too?

	Arnd
