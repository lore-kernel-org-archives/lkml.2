Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754879Ab2BEOeX (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Feb 2012 09:34:23 -0500
Received: from mail-ey0-f174.google.com ([209.85.215.174]:43188 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754033Ab2BEOeV convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Feb 2012 09:34:21 -0500
Content-Type: text/plain; charset=utf-8; format=flowed; delsp=yes
To: "Marek Szyprowski" <m.szyprowski@samsung.com>,
        "Hillf Danton" <dhillf@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-media@vger.kernel.org, linux-mm@kvack.org,
        linaro-mm-sig@lists.linaro.org,
        "Kyungmin Park" <kyungmin.park@samsung.com>,
        "Russell King" <linux@arm.linux.org.uk>,
        "Andrew Morton" <akpm@linux-foundation.org>,
        "KAMEZAWA Hiroyuki" <kamezawa.hiroyu@jp.fujitsu.com>
Subject: Re: [PATCH 05/15] mm: compaction: export some of the functions
References: <1328271538-14502-1-git-send-email-m.szyprowski@samsung.com>
 <1328271538-14502-6-git-send-email-m.szyprowski@samsung.com>
 <CAJd=RBBsTxV4bM_QEbKaU=uKkFTNgPEK4yTiLjbE0TaEp4KA7w@mail.gmail.com>
Date: Sun, 05 Feb 2012 15:34:15 +0100
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
From: "Michal Nazarewicz" <mina86@mina86.com>
Message-ID: <op.v87mrdg83l0zgt@mpn-glaptop>
In-Reply-To: <CAJd=RBBsTxV4bM_QEbKaU=uKkFTNgPEK4yTiLjbE0TaEp4KA7w@mail.gmail.com>
User-Agent: Opera Mail/11.61 (Linux)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> On Fri, Feb 3, 2012 at 8:18 PM, Marek Szyprowski
> <m.szyprowski@samsung.com> wrote:
>> From: Michal Nazarewicz <mina86@mina86.com>
>>
>> This commit exports some of the functions from compaction.c file
>> outside of it adding their declaration into internal.h header
>> file so that other mm related code can use them.
>>
>> This forced compaction.c to always be compiled (as opposed to being
>> compiled only if CONFIG_COMPACTION is defined) but as to avoid
>> introducing code that user did not ask for, part of the compaction.c
>> is now wrapped in on #ifdef.

On Sun, 05 Feb 2012 08:40:08 +0100, Hillf Danton <dhillf@gmail.com> wrote:
> What if both compaction and CMA are not enabled?

What about it?  If both are enabled, both will be compiled and usable.

-- 
Best regards,                                         _     _
.o. | Liege of Serenely Enlightened Majesty of      o' \,=./ `o
..o | Computer Science,  Michał “mina86” Nazarewicz    (o o)
ooo +----<email/xmpp: mpn@google.com>--------------ooO--(_)--Ooo--
