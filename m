Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933461Ab1JDTKY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Oct 2011 15:10:24 -0400
Received: from moutng.kundenserver.de ([212.227.17.8]:54499 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932820Ab1JDTKW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Oct 2011 15:10:22 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Mark Salter <msalter@redhat.com>
Cc: linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
        Aurelien Jacquiot <a-jacquiot@ti.com>
Subject: Re: [PATCH v4 08/24] C6X: memory management and DMA support
Date: Tue, 04 Oct 2011 21:10:10 +0200
Message-ID: <2022911.6LdT5ms78P@wuerfel>
User-Agent: KMail/4.7.1 (Linux/3.1.0-rc8nosema+; KDE/4.7.1; x86_64; ; )
In-Reply-To: <1317746641-26725-9-git-send-email-msalter@redhat.com>
References: <1317746641-26725-1-git-send-email-msalter@redhat.com> <1317746641-26725-9-git-send-email-msalter@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:I8ky+wlNQboS4Ge6S6YFmitqUjvsn+dJbRrhCmtA1E/
 yOlJg1t/DDLf9S+zfGgFjD+8qiSz3qX0N/B5PrdQUQJdHJzMJg
 AYnBhl9Iyxt6cLKtEKyrQ5TN46g6R5C8Mg0pb/BxY+Jn4Q6nSK
 urzZeb2sR9a76STbe9PXwHU20M7D0xi4HKoteCRvfgLgNTfCQX
 KpJdKHn1dzuvKObmuYzqOoDllgmyKtNi+4CSiOlRsxTbrHTfEB
 XG/V1DuCkWdZ8a2QZVgABNDjXiKj/jdGEEVPTfsK+vZhfAEn59
 +Yox6lAJPo6T7OZ8X/Tbse+Nv9mEITCxyTaly2JTvykpZYFf56
 fwS5ruWEW+Nh2PbYbx+Q=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 04 October 2011 12:43:45 Mark Salter wrote:
> From: Aurelien Jacquiot <a-jacquiot@ti.com>
> 
> Original port to early 2.6 kernel using TI COFF toolchain.
> Brought up to date by Mark Salter <msalter@redhat.com>
> 
> The C6X architecture currently lacks an MMU so memory management is relatively
> simple. There is no bus snooping between L2 and main memory but coherent DMA
> memory is supported by making regions of main memory uncached. If such a region
> is desired, it can be specified on the commandline with a "memdma=" argument.
> 
> Signed-off-by: Aurelien Jacquiot <a-jacquiot@ti.com>
> Signed-off-by: Mark Salter <msalter@redhat.com>
> CC: Arnd Bergmann <arnd@arndb.de>


Acked-by: Arnd Bergmann <arnd@arndb.de>
