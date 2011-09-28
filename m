Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754320Ab1I1Nrd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Sep 2011 09:47:33 -0400
Received: from moutng.kundenserver.de ([212.227.126.186]:60275 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754287Ab1I1Nrb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Sep 2011 09:47:31 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Mark Salter <msalter@redhat.com>
Subject: Re: [PATCH v3 09/24] C6X: process management
Date: Wed, 28 Sep 2011 15:47:23 +0200
User-Agent: KMail/1.12.2 (Linux/2.6.35-22-generic; KDE/4.3.2; x86_64; ; )
Cc: linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org
References: <1317155405-26235-1-git-send-email-msalter@redhat.com> <1317155405-26235-10-git-send-email-msalter@redhat.com>
In-Reply-To: <1317155405-26235-10-git-send-email-msalter@redhat.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201109281547.23430.arnd@arndb.de>
X-Provags-ID: V02:K0:FUHF43pqsTDXKzYknwRr9lm12ix7aIa0s/AYdfoneN9
 8CyJa3hCJJVRavqQ1wfZ5ZDeLlRKakB3PSlHCXMpCG7Q6EhzCI
 QIJr2zyCfWSjhXzMiDPJftTuawJnUG5acEGuteemnUCVW9bUGD
 sGCBd1kPMraDuCQB3p6CTW9Y7vgbaaahKXIy9g7b2zjRnc903O
 Ny3Tzh0aXB1vgV1T5l95Rou/rfg5WSg/qlzrciuV/HNeYuRwhH
 i/UzfXPFPiFe/dvx4H0GcIypNwqwsZ01FSEOWdmsW0C8h5TJMS
 vmkSdWomKoyuPn7/1J+Po9Mh9qc552wXpWwUXCgmpNsKXCjm8w
 BpYHTifb5X6Tm/6yQ6pE=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 27 September 2011, Mark Salter wrote:
> Signed-off-by: Mark Salter <msalter@redhat.com>
> ---
>  arch/c6x/include/asm/processor.h   |  132 ++++++++++++++++++
>  arch/c6x/include/asm/thread_info.h |  121 +++++++++++++++++
>  arch/c6x/kernel/process.c          |  263 ++++++++++++++++++++++++++++++++++++
>  arch/c6x/kernel/switch_to.S        |   74 ++++++++++
>  4 files changed, 590 insertions(+), 0 deletions(-)
>  create mode 100644 arch/c6x/include/asm/processor.h
>  create mode 100644 arch/c6x/include/asm/thread_info.h
>  create mode 100644 arch/c6x/kernel/process.c
>  create mode 100644 arch/c6x/kernel/switch_to.S

Acked-by: Arnd Bergmann <arnd@arndb.de>
