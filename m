Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751996Ab2LJFy0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Dec 2012 00:54:26 -0500
Received: from mx1.redhat.com ([209.132.183.28]:40611 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751792Ab2LJFyZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Dec 2012 00:54:25 -0500
Date: Mon, 10 Dec 2012 11:24:01 +0530
From: Amit Shah <amit.shah@redhat.com>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: sjur@brendeland.net, "Michael S. Tsirkin" <mst@redhat.com>,
        linus.walleij@linaro.org, masami.hiramatsu.pt@hitachi.com,
        ohad@wizery.com, linux-kernel@vger.kernel.org,
        virtualization@lists.linux-foundation.org,
        Sjur =?iso-8859-1?Q?Br=E6ndeland?= 
	<sjur.brandeland@stericsson.com>
Subject: Re: [[PATCH v9 3/3] 1/1] virtio_console: Remove buffers from out_vq
 at port removal
Message-ID: <20121210055401.GA17187@amit.redhat.com>
References: <029d7029bc1186fbd2ec74123dc88922b9600660.1352366215.git.amit.shah@redhat.com>
 <87ip96id3a.fsf@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <87ip96id3a.fsf@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On (Fri) 16 Nov 2012 [11:22:09], Rusty Russell wrote:
> Amit Shah <amit.shah@redhat.com> writes:
> > From: Sjur Brændeland <sjur.brandeland@stericsson.com>
> >
> > Remove buffers from the out-queue when a port is removed. Rproc_serial
> > communicates with remote processors that may crash and leave buffers in
> > the out-queue. The virtio serial ports may have buffers in the out-queue
> > as well, e.g. for non-blocking ports and the host didn't consume them
> > yet.
> >
> > [Amit: Remove WARN_ON for generic ports case.]
> >
> > Signed-off-by: Sjur Brændeland <sjur.brandeland@stericsson.com>
> > Signed-off-by: Amit Shah <amit.shah@redhat.com>
> 
> I already have this in my pending queue; I've promoted it to my
> virtio-next branch now.

Rusty, I still see this series in your pending queue, not in
virtio-next.  Did anything change in the meantime?

		Amit
