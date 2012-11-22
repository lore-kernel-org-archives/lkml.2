Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932275Ab2KVSuY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Nov 2012 13:50:24 -0500
Received: from mail-wi0-f170.google.com ([209.85.212.170]:56357 "EHLO
	mail-wi0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932225Ab2KVSuO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Nov 2012 13:50:14 -0500
MIME-Version: 1.0
In-Reply-To: <alpine.DEB.2.00.1211220431150.14614@skynet.skynet.ie>
References: <alpine.DEB.2.00.1211220431150.14614@skynet.skynet.ie>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Wed, 21 Nov 2012 18:50:52 -1000
X-Google-Sender-Auth: n87865JfpUNPYxwdSKyBcBMvxcM
Message-ID: <CA+55aFw3yqWRamfe3tn4Lh9G2BsuNd1RsST05=fc4jOoTLWsmw@mail.gmail.com>
Subject: Re: [git pull] drm fixes
To: Dave Airlie <airlied@linux.ie>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        DRI mailing list <dri-devel@lists.freedesktop.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 21, 2012 at 6:34 PM, Dave Airlie <airlied@linux.ie> wrote:
>
> its vmware/nouveua/radeon/intel/ttm scattered.

Hmm. That's not what I see. I just see nouveau and soem PCI ID addition.

>  21 files changed, 108 insertions(+), 31 deletions(-)

I get

 14 files changed, 70 insertions(+), 21 deletions(-)

probably due to this.

Forgot to push? The tip of your tree that I see is 452f19201f35d
("Merge branch 'drm-fixes-3.7' of
git://people.freedesktop.org/~agd5f/linux into drm-fixes")

Or is it because you already sent me the intel fixes earlier?

                  Linus
