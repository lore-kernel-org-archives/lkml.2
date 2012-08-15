Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754843Ab2HONxI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Aug 2012 09:53:08 -0400
Received: from moutng.kundenserver.de ([212.227.17.9]:58284 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751913Ab2HONxF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Aug 2012 09:53:05 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Catalin Marinas <catalin.marinas@arm.com>
Subject: Re: [PATCH v2 07/31] arm64: Process management
Date: Wed, 15 Aug 2012 13:53:01 +0000
User-Agent: KMail/1.12.2 (Linux/3.5.0; KDE/4.3.2; x86_64; ; )
Cc: linux-arch@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, Will Deacon <will.deacon@arm.com>
References: <1344966752-16102-1-git-send-email-catalin.marinas@arm.com> <1344966752-16102-8-git-send-email-catalin.marinas@arm.com>
In-Reply-To: <1344966752-16102-8-git-send-email-catalin.marinas@arm.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="windows-1252"
Content-Transfer-Encoding: 7bit
Message-Id: <201208151353.01367.arnd@arndb.de>
X-Provags-ID: V02:K0:XdGB1YUziwuNX4siQ4xaN4E9p7zmkkMsAcHB8WA7q1B
 qIRfWyeogzebiIGGmCyaN/1+zSGF5cX1//t0Qwdh9pUqv3+L/e
 nK07rLUPXlXI/07pWjjzKMmT65k2M7dro8UaKMMgwwkiE2q0AK
 as0MRxSeAnBsUz14H1BobA87v4fetunAT5q7rBkNg3AtVgQ5Gr
 SItz7whxD7aBGh0SBQ17/ftJmF8itTTVi/xNLn+Ll0uEsM1xRT
 KJn8WpBfx07Qz9h4Kdx2Z8cEZKIunZW7dj55LwVmUeNboMQmoW
 6jueNhheInZGKMsPFg6ai4m2wfQGGIe81ceafArT7S+YRrUYIK
 1d2e5qQzzMejTwE+4qAs=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 14 August 2012, Catalin Marinas wrote:

> +#define THREAD_SIZE_ORDER	1
> +#define THREAD_SIZE		8192
> +#define THREAD_START_SP		(THREAD_SIZE - 16)

THREAD_SIZE_ORDER looks wrong for 64kb-page kernels. It also doesn't seem to
be used, so better remove it.

	Arnd

