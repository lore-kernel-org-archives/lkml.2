Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758596Ab0JUPHu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Oct 2010 11:07:50 -0400
Received: from moutng.kundenserver.de ([212.227.17.10]:56605 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752967Ab0JUPHs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Oct 2010 11:07:48 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Akinobu Mita <akinobu.mita@gmail.com>
Subject: Re: [PATCH v2 03/22] s390: introduce little-endian bitops
Date: Thu, 21 Oct 2010 17:08:00 +0200
User-Agent: KMail/1.12.2 (Linux/2.6.35-16-generic; KDE/4.3.2; x86_64; ; )
Cc: linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
        Christoph Hellwig <hch@infradead.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Heiko Carstens <heiko.carstens@de.ibm.com>, linux390@de.ibm.com,
        linux-s390@vger.kernel.org
References: <1287672077-5797-1-git-send-email-akinobu.mita@gmail.com> <1287672077-5797-4-git-send-email-akinobu.mita@gmail.com>
In-Reply-To: <1287672077-5797-4-git-send-email-akinobu.mita@gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201010211708.00606.arnd@arndb.de>
X-Provags-ID: V02:K0:JoCnoqYd/DDdgEpBRm1St6kDQyPNBsN2DyO8edHVDw2
 0Gk5mTzn/U90/dpG7G0XWdha0EfqlygWXH+67isqHykXEk+Twb
 wbJ1NCOtF38p7EhK0gQtRKVQqX6kdZjeHuWTlfj/hN0CB6l8PH
 kwSL/JK+I+b/U3VxqAxhFERrrvrjH7yHVZ/8/t0ZCop7grXpES
 KIc3seHsfDwVA3X55Km+A==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 21 October 2010, Akinobu Mita wrote:
> Introduce little-endian bit operations by renaming native ext2 bit
> operations. The ext2 bit operations are kept as wrapper macros using
> little-endian bit operations to maintain bisectability until the
> conversions are finished.
> 
> Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
> Cc: Martin Schwidefsky <schwidefsky@de.ibm.com>
> Cc: Heiko Carstens <heiko.carstens@de.ibm.com>
> Cc: linux390@de.ibm.com
> Cc: linux-s390@vger.kernel.org

Acked-by: Arnd Bergmann <arnd@arndb.de>
