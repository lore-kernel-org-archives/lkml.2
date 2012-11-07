Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753880Ab2KGDhW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Nov 2012 22:37:22 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:50861 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753282Ab2KGDhU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Nov 2012 22:37:20 -0500
MIME-Version: 1.0
In-Reply-To: <20121106152303.b1e135ee.akpm@linux-foundation.org>
References: <1351931714-11689-1-git-send-email-ming.lei@canonical.com>
	<20121106152303.b1e135ee.akpm@linux-foundation.org>
Date: Wed, 7 Nov 2012 11:37:19 +0800
Message-ID: <CACVXFVM8Z55mHV791TF19kH5J6u_yEXK_=nmu6qk2hiXzn+M9w@mail.gmail.com>
Subject: Re: [PATCH v4 0/6] solve deadlock caused by memory allocation with I/O
From: Ming Lei <ming.lei@canonical.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Alan Stern <stern@rowland.harvard.edu>,
        Oliver Neukum <oneukum@suse.de>, Minchan Kim <minchan@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "Rafael J. Wysocki" <rjw@sisk.pl>, Jens Axboe <axboe@kernel.dk>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        linux-usb@vger.kernel.org, linux-pm@vger.kernel.org,
        linux-mm@kvack.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 7, 2012 at 7:23 AM, Andrew Morton <akpm@linux-foundation.org> wrote:
>
> It generally looks OK to me.  I have a few comments and I expect to grab
> v5.

Andrew, thanks for your review, and I will prepare -v5 later.

Thanks,
--
Ming Lei
