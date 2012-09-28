Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757585Ab2I1Ms0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Sep 2012 08:48:26 -0400
Received: from mx1.redhat.com ([209.132.183.28]:29811 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753399Ab2I1MsZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Sep 2012 08:48:25 -0400
Date: Fri, 28 Sep 2012 18:18:10 +0530
From: Amit Shah <amit.shah@redhat.com>
To: sjur.brandeland@stericsson.com
Cc: linux-kernel@vger.kernel.org, virtualization@lists.linux-foundation.org,
        sjurbren@stericsson.com, Rusty Russell <rusty@rustcorp.com.au>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Subject: Re: [PATCHv6 0/3] virtio_console: Add rproc_serial device
Message-ID: <20120928124810.GB25916@amit.redhat.com>
References: <1348580837-10919-1-git-send-email-sjur.brandeland@stericsson.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1348580837-10919-1-git-send-email-sjur.brandeland@stericsson.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On (Tue) 25 Sep 2012 [15:47:14], sjur.brandeland@stericsson.com wrote:
> From: Sjur Brændeland <sjur.brandeland@stericsson.com>
> 
> I thought rebasing rproc_serial to linux-next was going to be trivial.
> But when starting the merge I realized that I had to refactor the
> the patches from  Masami Hiramatsu. The splice support has the same issue
> as I faced, with different type of buffers in the out_vq.
> So I ended up refactoring the splice functionality. The code
> size got smaller so hopefully this a step in the right direction.
> 
> This refactoring also make introduction of rproc_serial cleaner.
> 
> As requested I also added a patch for not initializing buffers.
> 
> I have tested the VIRTIO_CONSOLE device by looping large amount of data
> through character device and tty, with lockdep and slub-debug on.
> This looks stable for me. I've also done a simple test of splice.

Thanks; I just passed these patches through my testsuite and things
are working fine.  I'll review them in some time.

		Amit
