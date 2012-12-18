Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753787Ab2LREbH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Dec 2012 23:31:07 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:35835 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753130Ab2LREbG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Dec 2012 23:31:06 -0500
MIME-Version: 1.0
In-Reply-To: <CAGXu5jKmEaBHpWmzsfiiQTAqDTT0Sc-yWGFA7YKcRTDqXriitA@mail.gmail.com>
References: <20121214225125.GA30826@www.outflux.net>
	<CACVXFVMCWZCsMsp=tqYtVy7FYT_A369xFPorC3QwuFW-jTC-ow@mail.gmail.com>
	<CAGXu5j+n7vPVAbx+=Dyd81FfCKQcM9HzHRQBg-JQoBOwu5fZVw@mail.gmail.com>
	<CACVXFVMjUZKcKfbjjPfbZNJ91ZFw9XCJO8x6JYgrRb_5WFnmDA@mail.gmail.com>
	<CAGXu5jKmEaBHpWmzsfiiQTAqDTT0Sc-yWGFA7YKcRTDqXriitA@mail.gmail.com>
Date: Tue, 18 Dec 2012 12:31:03 +0800
Message-ID: <CACVXFVM2TFxAMV_Cn7NZrROLHnjULexxmY66NopznOF-Q6vPYA@mail.gmail.com>
Subject: Re: [PATCH] firmware: make sure paths remain relative
From: Ming Lei <ming.lei@canonical.com>
To: Kees Cook <keescook@chromium.org>
Cc: linux-kernel@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 18, 2012 at 12:09 PM, Kees Cook <keescook@chromium.org> wrote:
>
> Do you mean a printk should be emitted on this error path? I can add that if so.

dev_err() should be better. With that, please feel free to add

       Acked-by: Ming Lei <ming.lei@canonical.com>

Thanks,
--
Ming Lei
