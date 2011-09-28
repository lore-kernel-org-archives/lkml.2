Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754341Ab1I1NuD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Sep 2011 09:50:03 -0400
Received: from moutng.kundenserver.de ([212.227.17.8]:59178 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752913Ab1I1NuA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Sep 2011 09:50:00 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Mark Salter <msalter@redhat.com>
Subject: Re: [PATCH v3 13/24] C6X: syscalls
Date: Wed, 28 Sep 2011 15:49:52 +0200
User-Agent: KMail/1.12.2 (Linux/2.6.35-22-generic; KDE/4.3.2; x86_64; ; )
Cc: linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org
References: <1317155405-26235-1-git-send-email-msalter@redhat.com> <1317155405-26235-14-git-send-email-msalter@redhat.com>
In-Reply-To: <1317155405-26235-14-git-send-email-msalter@redhat.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201109281549.52804.arnd@arndb.de>
X-Provags-ID: V02:K0:EnBZAwG4j5R7TX9WrZd7iD2n2tZxz+NHmyW4EkatYbG
 cxb6MthsyzhKl+vfX0MvuA1hvURwvvWkGALjP5Wbf5B/zjHA3v
 pohEEnCnmtSE92YYjSjmEbeCxlR/mdIw+HrecMYuCQZGDCpAVC
 A7ZicF1HpRr6zfHGOnb9VdES+Jr98p0If65GqBdTG1KQZpQDyA
 8btUNTKMTztx7c+yVPZA7WMuJyzu3677/nVSc4nVJl5CaZSeuP
 ErpjgJaHsBfnodRE7qoMNHFUpsd+bTE4bRYwxyjFT4lxwn5hTm
 ukcpzslu3wahdOjHSAaHulaHRTc8NkT3FUO0bqsqj+w5R2x1EW
 vPNPSHzBsQswe/rWFZwk=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 27 September 2011, Mark Salter wrote:
> Signed-off-by: Mark Salter <msalter@redhat.com>
> ---
>  arch/c6x/include/asm/syscalls.h |   55 +++++++++++++++++++++++++++++
>  arch/c6x/include/asm/unistd.h   |   26 ++++++++++++++
>  arch/c6x/kernel/sys_c6x.c       |   73 +++++++++++++++++++++++++++++++++++++++
>  3 files changed, 154 insertions(+), 0 deletions(-)
>  create mode 100644 arch/c6x/include/asm/syscalls.h
>  create mode 100644 arch/c6x/include/asm/unistd.h
>  create mode 100644 arch/c6x/kernel/sys_c6x.c

Acked-by: Arnd Bergmann <arnd@arndb.de>
