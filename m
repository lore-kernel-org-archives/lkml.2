Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752944Ab2KDXrt (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Nov 2012 18:47:49 -0500
Received: from ozlabs.org ([203.10.76.45]:38602 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752002Ab2KDXrp convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Nov 2012 18:47:45 -0500
From: Rusty Russell <rusty@rustcorp.com.au>
To: Sjur =?utf-8?Q?Br=C3=A6ndeland?= <sjur@brendeland.net>
Cc: "Michael S. Tsirkin" <mst@redhat.com>, Amit Shah <amit.shah@redhat.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Ohad Ben-Cohen <ohad@wizery.com>, linux-kernel@vger.kernel.org,
        virtualization@lists.linux-foundation.org, sjurbren@gmail.com,
        Sjur =?utf-8?Q?Br=C3=A6ndeland?= <sjur.brandeland@stericsson.com>
Subject: Re: [PATCHv8 0/3]virtio_console: Add rproc_serial driver
In-Reply-To: <1351587113-2566-1-git-send-email-sjur@brendeland.net>
References: <1351587113-2566-1-git-send-email-sjur@brendeland.net>
User-Agent: Notmuch/0.14 (http://notmuchmail.org) Emacs/23.4.1 (i686-pc-linux-gnu)
Date: Mon, 05 Nov 2012 09:11:45 +1030
Message-ID: <877gq1yora.fsf@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sjur Brændeland <sjur@brendeland.net> writes:

> From: Sjur Brændeland <sjur.brandeland@stericsson.com>
>
> This patch-set introduces a new virtio type "rproc_serial" for communicating
> with remote processors over shared memory. The driver depends on the
> the remoteproc framework. As preparation for introducing "rproc_serial"
> I've done a refactoring of the transmit buffer handling.
>
> Changes since v7:
> - Rebased to virtio-next branch.
> - Removed extra added lines.
> - Removed superfluous checks before calling reclaim_dma_bufs().
> - Rusty raised some question regarding garbage collection of the
>   out-vq, so I moved this into a separate patch.

OK, I'm not sure that WARN_ON won't fire, but that's not all that
harmful.

Applied,
Rusty.
