Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755441Ab2DEHmA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Apr 2012 03:42:00 -0400
Received: from mailout1.w1.samsung.com ([210.118.77.11]:19166 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751890Ab2DEHl7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Apr 2012 03:41:59 -0400
Date: Thu, 05 Apr 2012 09:41:55 +0200
From: Marek Szyprowski <m.szyprowski@samsung.com>
Subject: RE: Linux 3.4-rc1
In-reply-to: <CAJL_dMt55kRBw71om9FLdT=XbsbaY2RB5_BsBeEqFCk7f-5=0Q@mail.gmail.com>
To: "'Anca Emanuel'" <anca.emanuel@gmail.com>,
        "'Subash Patel'" <subashrp@gmail.com>
Cc: "'Kyungmin Park'" <kmpark@infradead.org>,
        "'Rob Clark'" <rob.clark@linaro.org>, linaro-dev@lists.linaro.org,
        "'Linus Torvalds'" <torvalds@linux-foundation.org>,
        "'Linux Kernel Mailing List'" <linux-kernel@vger.kernel.org>,
        dri-devel@lists.freedesktop.org
Message-id: <00c001cd12ff$933d7010$b9b85030$%szyprowski@samsung.com>
Organization: SPRC
MIME-version: 1.0
X-Mailer: Microsoft Office Outlook 12.0
Content-type: text/plain; charset=us-ascii
Content-language: pl
Content-transfer-encoding: 7BIT
Thread-index: Ac0SXzTCQ90jMx1OTnqtXGM1DThjxAAD4qxQ
References: <CA+55aFy4aFGRLUrF+rYN3dskTepBtC+=x3B3bc_rzf1OaN_5pw@mail.gmail.com>
 <CAN_cFWMcttuebg_i8iWc+szDYMFT7gR=VJW0VtRj0Dh061Ob=A@mail.gmail.com>
 <CAH9JG2VujPUQfJ=7nyqM90jzuf60qqNYVi4fN40F1SpDua75gg@mail.gmail.com>
 <20120402084152.GA4612@phenom.ffwll.local> <4F7C3D84.1080407@gmail.com>
 <CAJL_dMt55kRBw71om9FLdT=XbsbaY2RB5_BsBeEqFCk7f-5=0Q@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Wednesday, April 04, 2012 2:34 PM Anca Emanuel

> @Subash Patel, prime is already included.
> 
> Why the CMA is at 24 version and still not included ?
> Linus, please include
> CMA,git://git.linaro.org/people/mszyprowski/linux-dma-mapping.git
> 3.4-rc1-cma-v24

CMA is expected to be merged via akpm tree together with other core memory management
patches. I got a message that Andrew Morton scheduled it for v3.5 kernel, so it should
be soon available in linux-next tree.

Best regards
-- 
Marek Szyprowski
Samsung Poland R&D Center

