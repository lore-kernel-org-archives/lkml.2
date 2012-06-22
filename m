Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761498Ab2FVLLn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Jun 2012 07:11:43 -0400
Received: from h9.dl5rb.org.uk ([81.2.74.9]:56586 "EHLO h5.dl5rb.org.uk"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1758182Ab2FVLLm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Jun 2012 07:11:42 -0400
Date: Fri, 22 Jun 2012 12:11:32 +0100
From: Ralf Baechle <ralf@linux-mips.org>
To: Huacai Chen <chenhuacai@gmail.com>
Cc: Arnaud Patard <arnaud.patard@rtp-net.org>, linux-mips@linux-mips.org,
        linux-kernel@vger.kernel.org, Fuxin Zhang <zhangfx@lemote.com>,
        Zhangjin Wu <wuzhangjin@gmail.com>, Huacai Chen <chenhc@lemote.com>,
        Hongliang Tao <taohl@lemote.com>, Hua Yan <yanh@lemote.com>,
        dri-devel@lists.freedesktop.org
Subject: Re: [PATCH V3 11/16] drm/radeon: Make radeon card usable for
 Loongson.
Message-ID: <20120622111131.GB18249@linux-mips.org>
References: <1340334073-17804-1-git-send-email-chenhc@lemote.com>
 <1340334073-17804-12-git-send-email-chenhc@lemote.com>
 <87txy3sn20.fsf@lebrac.rtp-net.org>
 <CAAhV-H5q5G87UMn0ixPUVZNcEV1b_qBHJKVKmCJsmzKdEB--4A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAAhV-H5q5G87UMn0ixPUVZNcEV1b_qBHJKVKmCJsmzKdEB--4A@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 22, 2012 at 06:55:40PM +0800, Huacai Chen wrote:

> > btw, would it be a good idea to use uncached accelerated instead ?
> I have tried uncached accelerated, there will be random points in the
> monitor, it seems a hw issue...

Have you flushed the pages from memory before switching their cache mode
to uncached accelerated?  The MIPS architecture defines the result of
mixing cache modes as UNPREDICTABLE so be careful to flush caches before
switching cache mode of a page.

  Ralf
