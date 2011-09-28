Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754458Ab1I1Nwi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Sep 2011 09:52:38 -0400
Received: from moutng.kundenserver.de ([212.227.126.187]:49742 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754429Ab1I1Nwg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Sep 2011 09:52:36 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Mark Salter <msalter@redhat.com>
Subject: Re: [PATCH v3 16/24] C6X: cache control
Date: Wed, 28 Sep 2011 15:52:34 +0200
User-Agent: KMail/1.12.2 (Linux/2.6.35-22-generic; KDE/4.3.2; x86_64; ; )
Cc: linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org
References: <1317155405-26235-1-git-send-email-msalter@redhat.com> <1317155405-26235-17-git-send-email-msalter@redhat.com>
In-Reply-To: <1317155405-26235-17-git-send-email-msalter@redhat.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201109281552.34322.arnd@arndb.de>
X-Provags-ID: V02:K0:jF/FiIj/6p+4gW7Ql+QbtloG3CUNQjz8D4kbI7dpZhF
 jM5tPxSuLZXAbrI+vaBy2qMg5pU7ap8YnS9r6DYWy4XLtPSG22
 CsjVG/vPq05bAqO8EUgeUgYPh0cqGP5IkLRHVQmozx27N98GsO
 Azbm5+QSTdcEEgVrqNna2ahhvUgWjcgbkdquwQ4OMTymKe+9Jp
 PPz0mPOqFakjo3eSIwV1/j4U6mKiJIp9ecAIKlbDVfFC8hWqQt
 NXoADp0GNeRhrADUVHiBE5JMQ0B/D60H0oY4foc19CnHdR5d2O
 xvfOEaWjub2jK97GGVMw0WoptBZuA/kHo+koaz3n4O7MVqJlGO
 +aPUsUS2ONAaMHRCwMBI=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 27 September 2011, Mark Salter wrote:
> 
> Signed-off-by: Mark Salter <msalter@redhat.com>
> ---
>  arch/c6x/include/asm/cache.h      |   90 ++++++++
>  arch/c6x/include/asm/cacheflush.h |   65 ++++++
>  arch/c6x/platforms/cache.c        |  445 +++++++++++++++++++++++++++++++++++++
>  3 files changed, 600 insertions(+), 0 deletions(-)
>  create mode 100644 arch/c6x/include/asm/cache.h
>  create mode 100644 arch/c6x/include/asm/cacheflush.h
>  create mode 100644 arch/c6x/platforms/cache.c

Acked-by: Arnd Bergmann <arnd@arndb.de>
