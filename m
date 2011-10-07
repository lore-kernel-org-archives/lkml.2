Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759664Ab1JGJ7T (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Oct 2011 05:59:19 -0400
Received: from moutng.kundenserver.de ([212.227.17.9]:61798 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752108Ab1JGJ7S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Oct 2011 05:59:18 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Eric Miao <eric.y.miao@gmail.com>
Subject: Re: [PATCH 12/26] ARM: pxa: pxa95x/saarb depends on pxa3xx code
Date: Fri, 7 Oct 2011 11:59:13 +0200
User-Agent: KMail/1.12.2 (Linux/2.6.37; KDE/4.3.2; x86_64; ; )
Cc: "Russell King - ARM Linux" <linux@arm.linux.org.uk>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Jason Chagas <jason.chagas@marvell.com>,
        Haojian Zhuang <haojian.zhuang@marvell.com>
References: <1317499438-14058-1-git-send-email-arnd@arndb.de> <1317499438-14058-13-git-send-email-arnd@arndb.de> <CAMPhdO-1ZZ28Z7affqgXWqwnbbAEhyC3_Tbgtdp2v+s4bqqQRQ@mail.gmail.com>
In-Reply-To: <CAMPhdO-1ZZ28Z7affqgXWqwnbbAEhyC3_Tbgtdp2v+s4bqqQRQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201110071159.13234.arnd@arndb.de>
X-Provags-ID: V02:K0:fF4RebpVUF7Zayd+4L6nsy9G4mcZAf0t9koWQ3L639y
 2jNoEUuDyiwn42BnvbEzVOwq/hiDo+Z1mD7Uulxr779mP7Fvar
 Tej9A+jYcaj7Ij5Nz6xKwdqBmDvNSY2AE1/PPbey0weM2JUNNf
 eELnck+CBsvm2CQFNOybrQqrhoBR1rocPrZmxDk8dev+7GKHpE
 90XMXqnmXB/4Bf5pbeEix9H8VSm0T8f7WPBU2M4O6UiG+CijwU
 /1NFhebP+8IC5ZwawpoPovS4zJrgfPdDqJfURFerxU6W6baLmF
 tS2acjHGKMJwecfUVIIbowca2jeCOlLSTvmLJ8NxZHS7hZq1VE
 PTq4fH2i31gWR0yic66s=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 07 October 2011, Eric Miao wrote:
> PXA95x is actually PJ4 based, which is ARMv7/v6 compatible, not
> like it's predecessor PXA93x. Although they are currently sharing
> some code, I expect a fork in the near future. To cause less confusion
> here, I'd propose to further introduce pxa95x.h, and to remove
> the unnecessary #include of <mach/mfp.h> and <mach/mfp-pxa930.h>

Yes, looks good.

	Arnd
