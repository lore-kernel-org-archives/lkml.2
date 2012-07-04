Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932223Ab2GDGw3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jul 2012 02:52:29 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:18839 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754041Ab2GDGw2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jul 2012 02:52:28 -0400
X-AuditID: cbfee61a-b7f086d000000e64-30-4ff3e81e62f2
From: Marek Szyprowski <m.szyprowski@samsung.com>
To: "'Michal Nazarewicz'" <mina86@mina86.com>,
        "'Barry Song'" <21cnbao@gmail.com>
Cc: "'Barry Song'" <Barry.Song@csr.com>, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, workgroup.linux@csr.com,
        "'Barry Song'" <Baohua.Song@csr.com>
References: <1331120259-30780-1-git-send-email-Barry.Song@csr.com>
 <03e601cd58ec$5b8177b0$12846710$%szyprowski@samsung.com>
 <CAGsJ_4yjV+HDXdYraJ6CdJrSz1EPGgE6BRvO-_9n+6_UWfxqww@mail.gmail.com>
 <op.wgvfgmm03l0zgt@mpn-glaptop>
In-reply-to: <op.wgvfgmm03l0zgt@mpn-glaptop>
Subject: RE: [PATCH v4] mm: cma: add a simple kernel module as the helper to
 test CMA
Date: Wed, 04 Jul 2012 08:52:01 +0200
Organization: SPRC
Message-id: <000301cd59b1$87094eb0$951bec10$%szyprowski@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=utf-8
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac1ZGveABTuDXps0TIitfJxuoXMHIwAkYKhQ
Content-language: pl
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrOLMWRmVeSWpSXmKPExsVy+t9jAV25F5/9Da73aVhc3jWHzYHR4/Mm
	uQDGKC6blNSczLLUIn27BK6MraeWMRVM4ap4s/EsUwNjO0cXIyeHhICJxLwDO9ggbDGJC/fW
	A9lcHEICixgldrWsZoFwZjFJLJr8GqyKTcBQouttF5gtIuArsbuhG6yIWWAVo8S9/TMYITqe
	MUoc2XoSrIpTQEfizqZjrF2MHBzCAuES+1eZg4RZBFQldl47zg4S5hcQkpg4SwEkzCvgIjFp
	+X9mCFtQ4sfkeywgJcwC6hJTpuSChJkF5CU2r3nLDBKWAAo/+qsLcY2RxNLZ89ghSkQk7jY8
	Z53AKDwLyaBZCINmIRk0C0nHAkaWVYyiqQXJBcVJ6bmGesWJucWleel6yfm5mxjBwf1Magfj
	ygaLQ4wCHIxKPLwTHnz2F2JNLCuuzD3EKMHBrCTCe3M3UIg3JbGyKrUoP76oNCe1+BCjNAeL
	kjhvk/UFfyGB9MSS1OzU1ILUIpgsEwenVANj9pm1su9c2zl5A/8XrvA6vvi20Kz1JYGxgc8m
	BMmxPV3XIN5io6Aa+ufM3YtrV81cYHLtmuSksEc+E5dtiC1pzLmXfUjvzOsJhrJHOrjqWcRD
	jVr6i4Nlln+cZTSli3cty235IH8dc9napTkRXttPvzoos7DeKLt/f5LrxPxF+ZuqM8K3N7xV
	YinOSDTUYi4qTgQACedg5WoCAAA=
X-TM-AS-MML: No
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Tuesday, July 03, 2012 2:54 PM Michal Nazarewicz wrote:

> > 2012/7/3 Marek Szyprowski <m.szyprowski@samsung.com>:
> >> IMHO the right place for such code is in drivers/misc instead of tools/cma.
> >>
> >> This patch contains a kernel module source code so it should be put with other kernel
> >> modules. tools/ directory is aimed to contain user space code useful for developing and
> >> testing Linux kernel.
> 
> On Tue, 03 Jul 2012 09:39:34 +0200, Barry Song <21cnbao@gmail.com> wrote:
> > this one is aiming to test CMA, it should be in tools/ as Michal
> > Nazarewicz and i have talked about that.
> > it is not a real driver at all.
> 
> Yeah, I feel like it's better placed in tools/ not to pollute other directories with
> drivers that are of no use to regular users.  I don't have strong feelings about it
> though, so I'm fine either way.

Other test devices/drivers are in drivers directory (drivers/usb/misc/usbtest.c for
example), I don't see any good reason for polluting tools/ directory with kernel code. 

IMHO the right person to decide if it makes sense to have such drivers in drivers/mics/
or tools/cma/ is Greg KH. Barry, please resend it and ask Greg for the decision.

Best regards
-- 
Marek Szyprowski
Samsung Poland R&D Center


