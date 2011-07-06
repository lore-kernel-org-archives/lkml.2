Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755652Ab1GFTDL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jul 2011 15:03:11 -0400
Received: from smtp107.prem.mail.ac4.yahoo.com ([76.13.13.46]:33521 "HELO
	smtp107.prem.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1755495Ab1GFTDJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jul 2011 15:03:09 -0400
X-Yahoo-SMTP: _Dag8S.swBC1p4FJKLCXbs8NQzyse1SYSgnAbY0-
X-YMail-OSG: aApGf8gVM1ksftYOfpK6iP5h3BZ5h7ZfBwuDiZ2aw4sF7yk
 yqNYoZH1XHh8o_YuccPAj5z6wJlOHQlpWnhK0RmxZoQqKQyngNDW_JG2OLiu
 bu4tlBuV8XSGRy_ibsrt8_xEqC3ZiUsSBbmqSExPJFbMI3XYuMmTMrJ7ohfL
 qAHZ1sNNXNf3TE_6IaotkdzaK.HzKecSJGsw9xxvWPuQ1QthpKEXs.onqALw
 7Z9FFZM94Fm9b3eAMPDeZTwT0IbUYO2tppGw6HId8ZqMlucp3nlxPr5QZJK1
 akv_EsJFvGbjUerKu_4enwL2os6aPlWRpptwTEh5VM65vft8-
X-Yahoo-Newman-Property: ymail-3
Date: Wed, 6 Jul 2011 14:03:02 -0500 (CDT)
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@router.home
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
cc: Michal Nazarewicz <mina86@mina86.com>, Arnd Bergmann <arnd@arndb.de>,
        linux-arm-kernel@lists.infradead.org,
        "'Daniel Walker'" <dwalker@codeaurora.org>,
        "'Jonathan Corbet'" <corbet@lwn.net>, "'Mel Gorman'" <mel@csn.ul.ie>,
        "'Chunsang Jeong'" <chunsang.jeong@linaro.org>,
        "'Jesse Barker'" <jesse.barker@linaro.org>,
        "'KAMEZAWA Hiroyuki'" <kamezawa.hiroyu@jp.fujitsu.com>,
        linux-kernel@vger.kernel.org, linaro-mm-sig@lists.linaro.org,
        linux-mm@kvack.org, "'Kyungmin Park'" <kyungmin.park@samsung.com>,
        "'Ankita Garg'" <ankita@in.ibm.com>,
        "'Andrew Morton'" <akpm@linux-foundation.org>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        linux-media@vger.kernel.org, Andi Kleen <andi@firstfloor.org>
Subject: Re: [PATCH 6/8] drivers: add Contiguous Memory Allocator
In-Reply-To: <20110706171542.GJ8286@n2100.arm.linux.org.uk>
Message-ID: <alpine.DEB.2.00.1107061402320.17624@router.home>
References: <1309851710-3828-1-git-send-email-m.szyprowski@samsung.com> <201107061609.29996.arnd@arndb.de> <20110706142345.GC8286@n2100.arm.linux.org.uk> <201107061651.49824.arnd@arndb.de> <20110706154857.GG8286@n2100.arm.linux.org.uk>
 <alpine.DEB.2.00.1107061100290.17624@router.home> <op.vx7ghajd3l0zgt@mnazarewicz-glaptop> <alpine.DEB.2.00.1107061114150.19547@router.home> <20110706171542.GJ8286@n2100.arm.linux.org.uk>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 6 Jul 2011, Russell King - ARM Linux wrote:

> So, ARM is no different from x86, with the exception that the 16MB DMA
> zone due to ISA ends up being different sizes on ARM depending on our
> restrictions.

Sounds good. Thank you.

