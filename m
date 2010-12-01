Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753581Ab0LAPl3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Dec 2010 10:41:29 -0500
Received: from moutng.kundenserver.de ([212.227.126.186]:63923 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750965Ab0LAPl2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Dec 2010 10:41:28 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Hans Ulli Kroll <ulli.kroll@googlemail.com>
Subject: Re: [PATCH] Kconfig: add new symbol MIGHT_HAVE_PCI
Date: Wed, 1 Dec 2010 16:41:22 +0100
User-Agent: KMail/1.12.2 (Linux/2.6.35-16-generic; KDE/4.3.2; x86_64; ; )
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Russell King <linux@arm.linux.org.uk>
References: <1291217412-9435-1-git-send-email-ulli.kroll@googlemail.com>
In-Reply-To: <1291217412-9435-1-git-send-email-ulli.kroll@googlemail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201012011641.22191.arnd@arndb.de>
X-Provags-ID: V02:K0:p11Q71X4mvp4PY8jT8XDduM82w0tMNJd8tsszGztSm2
 Hoee6iAmDPJSNWV3WrhhzD8otwj26oBr7aSlDyOPAkdPKsxXGD
 02ouoJIj/QpfWoqB7NgHfHx7HXwLDNlR7V1bWZec5fQeGVKyyh
 t2Axyit2932TLoCE9znHfPhXuMopj1yoGoLC8VESuv8L0Yh7sT
 0j2f85j2JKHFINLaZPCNQ==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 01 December 2010, Hans Ulli Kroll wrote:
> Today more boards with arm cpu have selectable pci bus.
> This patch makes this more scalable and remove line continuations in
> Kconfig
> 
> Cc: Arnd Bergmann <arnd@arndb.de>
> Signed-off-by: Hans Ulli Kroll <ulli.kroll@googlemail.com>

Looks good to me!

Acked-by: Arnd Bergmann <arnd@arndb.de>
