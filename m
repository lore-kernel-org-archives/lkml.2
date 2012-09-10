Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754837Ab2IJCaC (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Sep 2012 22:30:02 -0400
Received: from ozlabs.org ([203.10.76.45]:36051 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754241Ab2IJCaA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Sep 2012 22:30:00 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: Amit Shah <amit.shah@redhat.com>,
        Alexey Khoroshilov <khoroshilov@ispras.ru>
Cc: Arnd Bergmann <arnd@arndb.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        virtualization@lists.linux-foundation.org,
        linux-kernel@vger.kernel.org, ldv-project@ispras.ru
Subject: Re: [PATCH] virtio: console: fix error handling in init() function
In-Reply-To: <20120909201947.GF16985@amit.redhat.com>
References: <1346528977-23066-1-git-send-email-khoroshilov@ispras.ru> <20120909201947.GF16985@amit.redhat.com>
User-Agent: Notmuch/0.13.2 (http://notmuchmail.org) Emacs/23.3.1 (i686-pc-linux-gnu)
Date: Mon, 10 Sep 2012 11:49:37 +0930
Message-ID: <87627mfwli.fsf@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Amit Shah <amit.shah@redhat.com> writes:
> On (Sat) 01 Sep 2012 [23:49:37], Alexey Khoroshilov wrote:
>> If register_virtio_driver() fails, virtio-ports class is not destroyed.
>> The patch adds error handling of register_virtio_driver().
>> 
>> Found by Linux Driver Verification project (linuxtesting.org).
>> 
>> Signed-off-by: Alexey Khoroshilov <khoroshilov@ispras.ru>
>
> Acked-by: Amit Shah <amit.shah@redhat.com>
>
> Rusty, please pick this up.

Thanks for the CC.

Applied,
Rusty.
