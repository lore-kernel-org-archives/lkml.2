Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754607Ab1KVAeK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Nov 2011 19:34:10 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:37234 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752701Ab1KVAeJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Nov 2011 19:34:09 -0500
Date: Mon, 21 Nov 2011 16:34:07 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Vasiliy Kulikov <segooon@gmail.com>
Cc: kernel-hardening@lists.openwall.com, linux-kernel@vger.kernel.org,
        Alexey Dobriyan <adobriyan@gmail.com>,
        Al Viro <viro@zeniv.linux.org.uk>, "H. Peter Anvin" <hpa@zytor.com>,
        Greg KH <greg@kroah.com>, Theodore Tso <tytso@MIT.EDU>,
        Alan Cox <alan@lxorguk.ukuu.org.uk>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [RFC v2 1/3] procfs: parse mount options
Message-Id: <20111121163407.d8946ad8.akpm@linux-foundation.org>
In-Reply-To: <20111119110126.GA11468@albatros>
References: <20111119110126.GA11468@albatros>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 19 Nov 2011 15:01:26 +0400
Vasiliy Kulikov <segooon@gmail.com> wrote:

> This patch adds support of procfs mount options.
> Actual mount options are coming in the next patches.

The patches look sane to me.

I assume that `mount -o remount' has been tested and works as expected?

I also assume that any file which was opened prior to the remount will
remain accessible to any process which has the fd.  Is this acceptable
from a security/operational POV?

