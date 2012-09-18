Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932788Ab2IRLl5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Sep 2012 07:41:57 -0400
Received: from ozlabs.org ([203.10.76.45]:34890 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932711Ab2IRLlz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Sep 2012 07:41:55 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: Peter Senna Tschudin <peter.senna@gmail.com>
Cc: mst@redhat.com, virtualization@lists.linux-foundation.org,
        linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org,
        Peter Senna Tschudin <peter.senna@gmail.com>
Subject: Re: [PATCH] drivers/virtio/virtio_pci.c: fix error return code
In-Reply-To: <1347903077-19906-1-git-send-email-peter.senna@gmail.com>
References: <1347903077-19906-1-git-send-email-peter.senna@gmail.com>
User-Agent: Notmuch/0.13.2 (http://notmuchmail.org) Emacs/23.3.1 (i686-pc-linux-gnu)
Date: Tue, 18 Sep 2012 10:19:14 +0930
Message-ID: <878vc8qho5.fsf@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Peter Senna Tschudin <peter.senna@gmail.com> writes:

> From: Peter Senna Tschudin <peter.senna@gmail.com>
>
> Convert a nonnegative error return code to a negative one, as returned
> elsewhere in the function.

Thanks!

Applied,
Rusty.
