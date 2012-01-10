Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755426Ab2AJJQJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jan 2012 04:16:09 -0500
Received: from mail-we0-f174.google.com ([74.125.82.174]:62352 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752684Ab2AJJQE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jan 2012 04:16:04 -0500
Date: Tue, 10 Jan 2012 10:18:06 +0100
From: Daniel Vetter <daniel@ffwll.ch>
To: Thomas Hellstrom <thellstrom@vmware.com>
Cc: "dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>,
        James Simmons <jsimmons@infradead.org>,
        Jerome Glisse <j.glisse@gmail.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        linaro-mm-sig@lists.linaro.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, linux-media@vger.kernel.org
Subject: Re: [RFC] Future TTM DMA direction
Message-ID: <20120110091806.GC3979@phenom.ffwll.local>
Mail-Followup-To: Thomas Hellstrom <thellstrom@vmware.com>,
	"dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>,
	James Simmons <jsimmons@infradead.org>,
	Jerome Glisse <j.glisse@gmail.com>,
	Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
	linaro-mm-sig@lists.linaro.org,
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
	linux-media@vger.kernel.org
References: <4F0AB558.3050902@vmware.com>
 <20120109101105.GC3723@phenom.ffwll.local>
 <4F0AC908.90708@vmware.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4F0AC908.90708@vmware.com>
X-Operating-System: Linux phenom 3.2.0-rc6+
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Thomas,

On Mon, Jan 09, 2012 at 12:01:28PM +0100, Thomas Hellstrom wrote:
> Thanks for your input. I think this is mostly orthogonal to dma_buf, and
> really a way to adapt TTM to be DMA-api aware. That's currently done
> within the TTM backends. CMA was mearly included as an example that
> might not be relevant.
> 
> I haven't followed dma_buf that closely lately, but if it's growing
> from being just
> a way to share buffer objects between devices to something providing
> also low-level
> allocators with fragmentation prevention, there's definitely an overlap.
> However, on the dma_buf meeting in Budapest there seemed to be
> little or no interest
> in robust buffer allocation / fragmentation prevention although I
> remember bringing
> it up to the point where I felt annoying :).

Well, I've shot at you quite a bit too, and I still think it's too much
for the first few iterations. But I also think we will need a cleverer
dma subsystem sooner or later (even if it's just around dma_buf) so that's
why I've dragged your rfc out of the drm corner ;-)

Cheers, Daniel
-- 
Daniel Vetter
Mail: daniel@ffwll.ch
Mobile: +41 (0)79 365 57 48
