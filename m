Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754115Ab2LRBa7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Dec 2012 20:30:59 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:35297 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752425Ab2LRBa6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Dec 2012 20:30:58 -0500
MIME-Version: 1.0
In-Reply-To: <20121214225125.GA30826@www.outflux.net>
References: <20121214225125.GA30826@www.outflux.net>
Date: Tue, 18 Dec 2012 09:30:56 +0800
Message-ID: <CACVXFVMCWZCsMsp=tqYtVy7FYT_A369xFPorC3QwuFW-jTC-ow@mail.gmail.com>
Subject: Re: [PATCH] firmware: make sure paths remain relative
From: Ming Lei <ming.lei@canonical.com>
To: Kees Cook <keescook@chromium.org>
Cc: linux-kernel@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Dec 15, 2012 at 6:51 AM, Kees Cook <keescook@chromium.org> wrote:
> Some devices have configurable firmware locations. If these configuration
> mechanisms are exposed to unprivileged userspace, it may be possible to

I an wondering how the unprivileged userspace can write the firmware sysfs
to trigger loading firmware?

Thanks,
--
Ming Lei
