Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753769Ab2JVNB2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Oct 2012 09:01:28 -0400
Received: from mx1.redhat.com ([209.132.183.28]:28179 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753069Ab2JVNB1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Oct 2012 09:01:27 -0400
Date: Mon, 22 Oct 2012 18:30:52 +0530
From: Amit Shah <amit.shah@redhat.com>
To: sjur.brandeland@stericsson.com
Cc: Rusty Russell <rusty@rustcorp.com.au>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Ohad Ben-Cohen <ohad@wizery.com>, linux-kernel@vger.kernel.org,
        virtualization@lists.linux-foundation.org, sjurbren@gmail.com
Subject: Re: [PATCHv7 0/4] virtio_console: Add rproc_serial driver
Message-ID: <20121022130052.GG25057@amit.redhat.com>
References: <1350287856-5284-1-git-send-email-sjur.brandeland@stericsson.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1350287856-5284-1-git-send-email-sjur.brandeland@stericsson.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Sjur,

On (Mon) 15 Oct 2012 [09:57:32], sjur.brandeland@stericsson.com wrote:
> From: Sjur Brændeland <sjur.brandeland@stericsson.com>
> 
> This patch-set introduces a new virtio type "rproc_serial" for communicating
> with remote processors over shared memory. The driver depends on the
> the remoteproc framework. As preparation for introducing "rproc_serial"
> I've done a refactoring of the transmit buffer handling.
> 
> This patch-set is a rework of the patch-set from Sept 25th, hopefully all
> review comments has been addressed.
> 
> The fist patch is a bugfix and migth be applicable for 3.7.

Looks good,

Acked-by: Amit Shah <amit.shah@redhat.com>

include/linux/virtio_ids.h has moved to include/uapi/linux/.  Last
patch has to be re-spun for that.

Otherwise, I just checked if comments from the previous submission
were addressed.  The virtio-console test suite passes fine, so I
didn't really go through everything again.

Thanks,

		Amit
