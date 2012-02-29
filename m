Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932672Ab2B2NeZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Feb 2012 08:34:25 -0500
Received: from mail-bk0-f46.google.com ([209.85.214.46]:61927 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757995Ab2B2NeX convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Feb 2012 08:34:23 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of 21cnbao@gmail.com designates 10.205.132.1 as permitted sender) smtp.mail=21cnbao@gmail.com; dkim=pass header.i=21cnbao@gmail.com
MIME-Version: 1.0
In-Reply-To: <op.wafuu3kr3l0zgt@mpn-glaptop>
References: <1329929337-16648-1-git-send-email-m.szyprowski@samsung.com>
 <CAGsJ_4wgVcVjtAa6Qpki=8jSON7MfwJ8yumJ1YXE5p8L3PqUzw@mail.gmail.com> <op.wafuu3kr3l0zgt@mpn-glaptop>
From: Barry Song <21cnbao@gmail.com>
Date: Wed, 29 Feb 2012 21:34:02 +0800
Message-ID: <CAGsJ_4yk+Ca4RDP=sYaXvEKuJzYNhyZWQ7jfKnpR+zCm=3Dq6Q@mail.gmail.com>
Subject: Re: [Linaro-mm-sig] [PATCHv23 00/16] Contiguous Memory Allocator
To: Michal Nazarewicz <mina86@mina86.com>
Cc: Marek Szyprowski <m.szyprowski@samsung.com>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-media@vger.kernel.org,
        linux-mm@kvack.org, linaro-mm-sig@lists.linaro.org,
        Ohad Ben-Cohen <ohad@wizery.com>,
        Daniel Walker <dwalker@codeaurora.org>,
        Russell King <linux@arm.linux.org.uk>, Arnd Bergmann <arnd@arndb.de>,
        Jonathan Corbet <corbet@lwn.net>, Mel Gorman <mel@csn.ul.ie>,
        Dave Hansen <dave@linux.vnet.ibm.com>,
        Jesse Barker <jesse.barker@linaro.org>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Rob Clark <rob.clark@linaro.org>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        DL-SHA-WorkGroupLinux <workgroup.linux@csr.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Michal,

2012/2/29 Michal Nazarewicz <mina86@mina86.com>:
> On Wed, 29 Feb 2012 10:35:42 +0100, Barry Song <21cnbao@gmail.com> wrote:
>
>> 2012/2/23 Marek Szyprowski <m.szyprowski@samsung.com>:
>>
>>> This is (yet another) quick update of CMA patches. I've rebased them
>>> onto next-20120222 tree from
>>> git://git.kernel.org/pub/scm/linux/kernel/git/next/linux-next.git and
>>> fixed the bug pointed by Aaro Koskinen.
>>
>>
>> For the whole series:
>>
>> Tested-by: Barry Song <Baohua.Song@csr.com>
>>
>> and i also write a simple kernel helper to test the CMA:
>
>
> Would it make sense to make a patch out of it putting it to tools/cma (or
> similar)?

i can send a patch for this. i am just thinking, should it be placed
in tools/ as a test utility or Documents/ as an example to explain CMA
to users who want to use cma. i also think we should have a seperate
document to explain cma in details in documents/, and my helper
program can be placed there.

how do you think?
>
> --
> Best regards,                                         _     _
> .o. | Liege of Serenely Enlightened Majesty of      o' \,=./ `o
> ..o | Computer Science,  Michał “mina86” Nazarewicz    (o o)
> ooo +----<email/xmpp: mpn@google.com>--------------ooO--(_)--Ooo--

thanks
barry
