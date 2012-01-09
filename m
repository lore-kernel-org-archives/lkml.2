Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932111Ab2AIPRI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jan 2012 10:17:08 -0500
Received: from mail-vw0-f46.google.com ([209.85.212.46]:44538 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932077Ab2AIPRG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jan 2012 10:17:06 -0500
MIME-Version: 1.0
In-Reply-To: <CAAQKjZMEsuib18RYE7OvZPUqhKnvrZ8i3+EMuZSXr9KPVygo_Q@mail.gmail.com>
References: <1322816252-19955-1-git-send-email-sumit.semwal@ti.com>
	<1322816252-19955-2-git-send-email-sumit.semwal@ti.com>
	<CAAQKjZPFh6666JKc-XJfKYePQ_F0MNF6FkY=zKypWb52VVX3YQ@mail.gmail.com>
	<20120109081030.GA3723@phenom.ffwll.local>
	<CAAQKjZMEsuib18RYE7OvZPUqhKnvrZ8i3+EMuZSXr9KPVygo_Q@mail.gmail.com>
Date: Mon, 9 Jan 2012 09:17:05 -0600
X-Google-Sender-Auth: Hb85oXpaopm1exHlAI_oriuVQJ4
Message-ID: <CAF6AEGsTGOxyTX6Xijvm8UXGjtVTtYg5X5xfJo8D+47o+xU+bA@mail.gmail.com>
Subject: Re: [RFC v2 1/2] dma-buf: Introduce dma buffer sharing mechanism
From: Rob Clark <rob@ti.com>
To: InKi Dae <daeinki@gmail.com>
Cc: Sumit Semwal <sumit.semwal@ti.com>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-mm@kvack.org,
        linaro-mm-sig@lists.linaro.org, dri-devel@lists.freedesktop.org,
        linux-media@vger.kernel.org, linux@arm.linux.org.uk, arnd@arndb.de,
        jesse.barker@linaro.org, m.szyprowski@samsung.com,
        t.stanislaws@samsung.com, Sumit Semwal <sumit.semwal@linaro.org>,
        daniel@ffwll.ch
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 9, 2012 at 4:10 AM, InKi Dae <daeinki@gmail.com> wrote:
> note : in case of sharing a buffer between v4l2 and drm driver, the
> memory info would be copied vb2_xx_buf to xx_gem or xx_gem to
> vb2_xx_buf through sg table. in this case, only memory info is used to
> share, not some objects.

which v4l2/vb2 patches are you looking at?  The patches I was using,
vb2 holds a reference to the 'struct dma_buf *' internally, not just
keeping the sg_table

BR,
-R
