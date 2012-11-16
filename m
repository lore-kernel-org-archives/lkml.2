Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751310Ab2KPBQd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Nov 2012 20:16:33 -0500
Received: from ozlabs.org ([203.10.76.45]:36894 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751146Ab2KPBQc convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Nov 2012 20:16:32 -0500
From: Rusty Russell <rusty@rustcorp.com.au>
To: Amit Shah <amit.shah@redhat.com>
Cc: sjur@brendeland.net, "Michael S. Tsirkin" <mst@redhat.com>,
        linus.walleij@linaro.org, masami.hiramatsu.pt@hitachi.com,
        ohad@wizery.com, linux-kernel@vger.kernel.org,
        virtualization@lists.linux-foundation.org,
        Sjur =?utf-8?Q?Br=C3=A6ndeland?= <sjur.brandeland@stericsson.com>,
        Amit Shah <amit.shah@redhat.com>
Subject: Re: [[PATCH v9 3/3] 1/1] virtio_console: Remove buffers from out_vq at port removal
In-Reply-To: <029d7029bc1186fbd2ec74123dc88922b9600660.1352366215.git.amit.shah@redhat.com>
References: <029d7029bc1186fbd2ec74123dc88922b9600660.1352366215.git.amit.shah@redhat.com>
User-Agent: Notmuch/0.14 (http://notmuchmail.org) Emacs/23.4.1 (i686-pc-linux-gnu)
Date: Fri, 16 Nov 2012 11:22:09 +1030
Message-ID: <87ip96id3a.fsf@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Amit Shah <amit.shah@redhat.com> writes:
> From: Sjur Brændeland <sjur.brandeland@stericsson.com>
>
> Remove buffers from the out-queue when a port is removed. Rproc_serial
> communicates with remote processors that may crash and leave buffers in
> the out-queue. The virtio serial ports may have buffers in the out-queue
> as well, e.g. for non-blocking ports and the host didn't consume them
> yet.
>
> [Amit: Remove WARN_ON for generic ports case.]
>
> Signed-off-by: Sjur Brændeland <sjur.brandeland@stericsson.com>
> Signed-off-by: Amit Shah <amit.shah@redhat.com>

I already have this in my pending queue; I've promoted it to my
virtio-next branch now.

Thanks,
Rusty.
