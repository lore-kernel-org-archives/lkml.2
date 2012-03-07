Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757646Ab2CGMLS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Mar 2012 07:11:18 -0500
Received: from mail-ee0-f46.google.com ([74.125.83.46]:64344 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757548Ab2CGMLR convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Mar 2012 07:11:17 -0500
Content-Type: text/plain; charset=utf-8; format=flowed; delsp=yes
To: m.szyprowski@samsung.com, "Barry Song" <Barry.Song@csr.com>
Cc: workgroup.linux@csr.com, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        "Barry Song" <Baohua.Song@csr.com>
Subject: Re: [PATCH v4] mm: cma: add a simple kernel module as the helper to
 test CMA
References: <1331120259-30780-1-git-send-email-Barry.Song@csr.com>
Date: Wed, 07 Mar 2012 13:11:13 +0100
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
From: "Michal Nazarewicz" <mina86@mina86.com>
Message-ID: <op.wasuszai3l0zgt@mpn-glaptop>
In-Reply-To: <1331120259-30780-1-git-send-email-Barry.Song@csr.com>
User-Agent: Opera Mail/11.61 (Linux)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 07 Mar 2012 12:37:39 +0100, Barry Song <Barry.Song@csr.com> wrote:
> Any write request to /dev/cma_test will let the module to allocate memory from
> CMA, for example:
>
> 1st time
> $ echo 1024 > /dev/cma_test
> will require cma_test to request 1MB(1024KB)
> 2nd time
> $ echo 2048 > /dev/cma_test
> will require cma_test to request 2MB(2048KB)
>
> Any read request to /dev/cma_test will let the module to free the 1st valid
> memory from CMA, for example:
>
> 1st time
> $ cat /dev/cma_test
> will require cma_test to free the 1MB allocated in the first write request
> 2nd time
> $ cat /dev/cma_test
> will require cma_test to free the 2MB allocated in the second write request
>
> Signed-off-by: Barry Song <Baohua.Song@csr.com>

Reviewed-by: Michal Nazarewicz <mina86@mina86.com>

-- 
Best regards,                                         _     _
.o. | Liege of Serenely Enlightened Majesty of      o' \,=./ `o
..o | Computer Science,  Michał “mina86” Nazarewicz    (o o)
ooo +----<email/xmpp: mpn@google.com>--------------ooO--(_)--Ooo--
