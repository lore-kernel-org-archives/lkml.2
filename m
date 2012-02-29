Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932681Ab2B2Ngs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Feb 2012 08:36:48 -0500
Received: from mail-ee0-f46.google.com ([74.125.83.46]:55506 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932644Ab2B2Ngq convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Feb 2012 08:36:46 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of mnazarewicz@gmail.com designates 10.213.102.1 as permitted sender) smtp.mail=mnazarewicz@gmail.com; dkim=pass header.i=mnazarewicz@gmail.com
Content-Type: text/plain; charset=utf-8; format=flowed; delsp=yes
To: "Barry Song" <21cnbao@gmail.com>
Cc: "Marek Szyprowski" <m.szyprowski@samsung.com>,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-media@vger.kernel.org, linux-mm@kvack.org,
        linaro-mm-sig@lists.linaro.org, "Ohad Ben-Cohen" <ohad@wizery.com>,
        "Daniel Walker" <dwalker@codeaurora.org>,
        "Russell King" <linux@arm.linux.org.uk>,
        "Arnd Bergmann" <arnd@arndb.de>, "Jonathan Corbet" <corbet@lwn.net>,
        "Mel Gorman" <mel@csn.ul.ie>, "Dave Hansen" <dave@linux.vnet.ibm.com>,
        "Jesse Barker" <jesse.barker@linaro.org>,
        "Kyungmin Park" <kyungmin.park@samsung.com>,
        "Andrew Morton" <akpm@linux-foundation.org>,
        "Rob Clark" <rob.clark@linaro.org>,
        "KAMEZAWA Hiroyuki" <kamezawa.hiroyu@jp.fujitsu.com>,
        DL-SHA-WorkGroupLinux <workgroup.linux@csr.com>
Subject: Re: [Linaro-mm-sig] [PATCHv23 00/16] Contiguous Memory Allocator
References: <1329929337-16648-1-git-send-email-m.szyprowski@samsung.com>
 <CAGsJ_4wgVcVjtAa6Qpki=8jSON7MfwJ8yumJ1YXE5p8L3PqUzw@mail.gmail.com>
 <op.wafuu3kr3l0zgt@mpn-glaptop>
 <CAGsJ_4yk+Ca4RDP=sYaXvEKuJzYNhyZWQ7jfKnpR+zCm=3Dq6Q@mail.gmail.com>
Date: Wed, 29 Feb 2012 14:36:42 +0100
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
From: "Michal Nazarewicz" <mina86@mina86.com>
Message-ID: <op.wafz3gv53l0zgt@mpn-glaptop>
In-Reply-To: <CAGsJ_4yk+Ca4RDP=sYaXvEKuJzYNhyZWQ7jfKnpR+zCm=3Dq6Q@mail.gmail.com>
User-Agent: Opera Mail/11.61 (Linux)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 29 Feb 2012 14:34:02 +0100, Barry Song <21cnbao@gmail.com> wrote:

> 2012/2/29 Michal Nazarewicz <mina86@mina86.com>:
>> On Wed, 29 Feb 2012 10:35:42 +0100, Barry Song <21cnbao@gmail.com> wrote:
>>> and i also write a simple kernel helper to test the CMA:

>> Would it make sense to make a patch out of it putting it to tools/cma (or
>> similar)?

> i can send a patch for this. i am just thinking, should it be placed
> in tools/ as a test utility or Documents/ as an example to explain CMA
> to users who want to use cma.

I'd put it in tools/.

> i also think we should have a seperate document to explain cma in details
> in documents/, and my helper program can be placed there.

I'm currently writing an article for LWN which I hope will also lead to something
worth putting in Documentation/.

-- 
Best regards,                                         _     _
.o. | Liege of Serenely Enlightened Majesty of      o' \,=./ `o
..o | Computer Science,  Michał “mina86” Nazarewicz    (o o)
ooo +----<email/xmpp: mpn@google.com>--------------ooO--(_)--Ooo--
