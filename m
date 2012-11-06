Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753797Ab2KFXXI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Nov 2012 18:23:08 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:39932 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752254Ab2KFXXG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Nov 2012 18:23:06 -0500
Date: Tue, 6 Nov 2012 15:23:03 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Ming Lei <ming.lei@canonical.com>
Cc: linux-kernel@vger.kernel.org, Alan Stern <stern@rowland.harvard.edu>,
        Oliver Neukum <oneukum@suse.de>, Minchan Kim <minchan@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "Rafael J. Wysocki" <rjw@sisk.pl>, Jens Axboe <axboe@kernel.dk>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        linux-usb@vger.kernel.org, linux-pm@vger.kernel.org,
        linux-mm@kvack.org, "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: [PATCH v4 0/6] solve deadlock caused by memory allocation with
 I/O
Message-Id: <20121106152303.b1e135ee.akpm@linux-foundation.org>
In-Reply-To: <1351931714-11689-1-git-send-email-ming.lei@canonical.com>
References: <1351931714-11689-1-git-send-email-ming.lei@canonical.com>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat,  3 Nov 2012 16:35:08 +0800
Ming Lei <ming.lei@canonical.com> wrote:

> This patchset try to solve one deadlock problem which might be caused
> by memory allocation with block I/O during runtime PM and block device
> error handling path. Traditionly, the problem is addressed by passing
> GFP_NOIO statically to mm, but that is not a effective solution, see
> detailed description in patch 1's commit log.

It generally looks OK to me.  I have a few comments and I expect to grab
v5.

Rafael, your thoughts?
