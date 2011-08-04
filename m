Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752177Ab1HDHRn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Aug 2011 03:17:43 -0400
Received: from www262.sakura.ne.jp ([202.181.97.72]:58837 "EHLO
	www262.sakura.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751197Ab1HDHRj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Aug 2011 03:17:39 -0400
X-Nat-Received: from [202.181.97.72]:55355 [ident-empty]
	by smtp-proxy.isp with TPROXY id 1312442149.28962
Message-Id: <201108040715.p747FnXa042677@www262.sakura.ne.jp>
Subject: Re: [3.0-git16] Oops at driver_uevent_store().
From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
To: lacombar@gmail.com, bunk@stusta.de
Cc: greg@kroah.com, akpm@linux-foundation.org, torvalds@linux-foundation.org,
        linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Date: Thu, 04 Aug 2011 16:15:49 +0900
References: <201108040221.p742Lk3R069631@www262.sakura.ne.jp> <CACqU3MWQsh2cS8ck=c1-bOy-W649j0FjtNeOQbPaijAaCQ9wgA@mail.gmail.com> <201108040355.p743tBkv092694@www262.sakura.ne.jp> <CACqU3MVbHPuOjg9cY_GWdBGz3HPw3u7R3S14OOObN8-CFXGVaw@mail.gmail.com>
In-Reply-To: <CACqU3MVbHPuOjg9cY_GWdBGz3HPw3u7R3S14OOObN8-CFXGVaw@mail.gmail.com>
Content-Type: text/plain; charset="ISO-2022-JP"
X-Anti-Virus: Kaspersky Anti-Virus for Linux Mail Server 5.6.44/RELEASE, bases: 04082011 #5784654, status: clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Arnaud Lacombe wrote:
> Marking `pci_eisa_driver' as __refdata fix the warning and leave the
> struct untouched:
> 
> diff --git a/drivers/eisa/pci_eisa.c b/drivers/eisa/pci_eisa.c
> index 30da70d..cdae207 100644
> --- a/drivers/eisa/pci_eisa.c
> +++ b/drivers/eisa/pci_eisa.c

This patch solved the oops. Thank you.
