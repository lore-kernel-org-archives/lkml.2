Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753272Ab2EYJRd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 May 2012 05:17:33 -0400
Received: from mail-qc0-f174.google.com ([209.85.216.174]:57827 "EHLO
	mail-qc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751074Ab2EYJRb convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 May 2012 05:17:31 -0400
MIME-Version: 1.0
In-Reply-To: <CAO_48GFE3=yQjKS4w7=pGjNe3yENbRrd4bcMTfADJSn7LKekPQ@mail.gmail.com>
References: <CAO_48GFE3=yQjKS4w7=pGjNe3yENbRrd4bcMTfADJSn7LKekPQ@mail.gmail.com>
From: Sumit Semwal <sumit.semwal@linaro.org>
Date: Fri, 25 May 2012 14:47:10 +0530
Message-ID: <CAO_48GGRRvCKVyY_s=oFgTb1vfjf8pSkHRf3jA8iFcdEHhwxVg@mail.gmail.com>
Subject: Re: [GIT PULL]: dma-buf updates for 3.5
To: torvalds@linux-foundation.org, linux-kernel@vger.kernel.org,
        DRI mailing list <dri-devel@lists.freedesktop.org>,
        linaro-mm-sig@lists.linaro.org, linux-media@vger.kernel.org
Cc: Jesse Barker <jesse.barker@linaro.org>, akpm@linux-foundation.org,
        Daniel Vetter <daniel@ffwll.ch>, Arnd Bergmann <arnd@arndb.de>,
        Dave Airlie <airlied@linux.ie>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

On 25 May 2012 13:25, Sumit Semwal <sumit.semwal@linaro.org> wrote:
> Hi Linus,
>
> Here's the first signed-tag pull request for dma-buf framework.
>
> Could you please pull the dma-buf updates for 3.5? This includes the
> following key items:
> - mmap support
> - vmap support
> - related documentation updates
>
> These are needed by various drivers to allow mmap/vmap of dma-buf
> shared buffers. Dave Airlie has some prime patches dependent on the
> vmap pull as well.
>
> Thanks and best regards,
> ~Sumit.
>
>
> The following changes since commit 76e10d158efb6d4516018846f60c2ab5501900bc:
>
>  Linux 3.4 (2012-05-20 15:29:13 -0700)
>
> are available in the git repository at:
>
>  ssh://sumitsemwal@git.linaro.org/~/public_git/linux-dma-buf.git
> tags/tag-for-linus-3.5
I am really sorry - I goofed up in the git URL (sent the ssh URL
instead). Could you please use

git://git.linaro.org/people/sumitsemwal/linux-dma-buf.git tags/tag-for-linus-3.5

instead, or should I send a new pull request with the corrected URL?

Thanks, and best regards,
~Sumit.
>
> for you to fetch changes up to b25b086d23eb852bf3cfdeb60409b4967ebb3c0c:
>
>  dma-buf: add initial vmap documentation (2012-05-25 12:51:11 +0530)
>
> ----------------------------------------------------------------
> dma-buf updates for 3.5
>
> ----------------------------------------------------------------
> Daniel Vetter (1):
>      dma-buf: mmap support
>
> Dave Airlie (2):
>      dma-buf: add vmap interface
>      dma-buf: add initial vmap documentation
>
> Sumit Semwal (1):
>      dma-buf: minor documentation fixes.
>
>  Documentation/dma-buf-sharing.txt |  109 ++++++++++++++++++++++++++++++++++---
>  drivers/base/dma-buf.c            |   99 ++++++++++++++++++++++++++++++++-
>  include/linux/dma-buf.h           |   33 +++++++++++
>  3 files changed, 233 insertions(+), 8 deletions(-)



-- 
Thanks and regards,

Sumit Semwal

Linaro Kernel Engineer - Graphics working group

Linaro.org │ Open source software for ARM SoCs

Follow Linaro: Facebook | Twitter | Blog
