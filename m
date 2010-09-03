Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758018Ab0ICMTP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Sep 2010 08:19:15 -0400
Received: from moutng.kundenserver.de ([212.227.126.186]:51456 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757754Ab0ICMTN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Sep 2010 08:19:13 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: Re: [PATCH -mm 8/8] add the common dma_addr_t typedef to include/linux/types.h
Date: Fri, 3 Sep 2010 14:19:09 +0200
User-Agent: KMail/1.12.2 (Linux/2.6.35-16-generic; KDE/4.3.2; x86_64; ; )
Cc: akpm@linux-foundation.org, linux-arch@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20100903094753S.fujita.tomonori@lab.ntt.co.jp> <1283474956-14710-8-git-send-email-fujita.tomonori@lab.ntt.co.jp>
In-Reply-To: <1283474956-14710-8-git-send-email-fujita.tomonori@lab.ntt.co.jp>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201009031419.09298.arnd@arndb.de>
X-Provags-ID: V02:K0:o2nN+SANdeAtTxNOGDoAg0LgntDx4fFAiJBED68ABGl
 GN7A+xvth79GKa6nrT+zNkqDQ9kWhdnvlGWMOas5VdpgLCK/6K
 aLnaQQllsM5VYQMefoQjnOjorOzGq5f4NMKw+BZITSoIXZzMKQ
 NG8XOU3qYZjj+oyF7/3vAsr3mCV86w1Ir6zG8PbAD7FMYWeoFf
 xHLGKkKTN1WeiU9tBekfQ==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 03 September 2010, FUJITA Tomonori wrote:
> All architectures can use the common dma_addr_t typedef now. We can
> remove the arch specific dma_addr_t.

Very nice!

> Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
> Cc: arnd@arndb.de

Acked-by: Arnd Bergmann <arnd@arndb.de>
