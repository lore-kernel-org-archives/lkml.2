Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756056Ab2GCMyS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jul 2012 08:54:18 -0400
Received: from mail-ee0-f46.google.com ([74.125.83.46]:50547 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751177Ab2GCMyQ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jul 2012 08:54:16 -0400
Content-Type: text/plain; charset=utf-8; format=flowed; delsp=yes
To: "Marek Szyprowski" <m.szyprowski@samsung.com>,
        "Barry Song" <21cnbao@gmail.com>
Cc: "Barry Song" <Barry.Song@csr.com>, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, workgroup.linux@csr.com,
        "Barry Song" <Baohua.Song@csr.com>
Subject: Re: [PATCH v4] mm: cma: add a simple kernel module as the helper to
 test CMA
References: <1331120259-30780-1-git-send-email-Barry.Song@csr.com>
 <03e601cd58ec$5b8177b0$12846710$%szyprowski@samsung.com>
 <CAGsJ_4yjV+HDXdYraJ6CdJrSz1EPGgE6BRvO-_9n+6_UWfxqww@mail.gmail.com>
Date: Tue, 03 Jul 2012 14:54:12 +0200
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
From: "Michal Nazarewicz" <mina86@mina86.com>
Message-ID: <op.wgvfgmm03l0zgt@mpn-glaptop>
In-Reply-To: <CAGsJ_4yjV+HDXdYraJ6CdJrSz1EPGgE6BRvO-_9n+6_UWfxqww@mail.gmail.com>
User-Agent: Opera Mail/12.01 (Linux)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> 2012/7/3 Marek Szyprowski <m.szyprowski@samsung.com>:
>> IMHO the right place for such code is in drivers/misc instead of tools/cma.
>>
>> This patch contains a kernel module source code so it should be put with other kernel
>> modules. tools/ directory is aimed to contain user space code useful for developing and
>> testing Linux kernel.

On Tue, 03 Jul 2012 09:39:34 +0200, Barry Song <21cnbao@gmail.com> wrote:
> this one is aiming to test CMA, it should be in tools/ as Michal
> Nazarewicz and i have talked about that.
> it is not a real driver at all.

Yeah, I feel like it's better placed in tools/ not to pollute other directories with
drivers that are of no use to regular users.  I don't have strong feelings about it
though, so I'm fine either way.

-- 
Best regards,                                         _     _
.o. | Liege of Serenely Enlightened Majesty of      o' \,=./ `o
..o | Computer Science,  Michał “mina86” Nazarewicz    (o o)
ooo +----<email/xmpp: mpn@google.com>--------------ooO--(_)--Ooo--
