Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756904Ab2JWImJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Oct 2012 04:42:09 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:45588 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756830Ab2JWImH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Oct 2012 04:42:07 -0400
MIME-Version: 1.0
In-Reply-To: <Pine.LNX.4.44L0.1210221516280.1724-100000@iolanthe.rowland.org>
References: <1350894794-1494-5-git-send-email-ming.lei@canonical.com>
	<Pine.LNX.4.44L0.1210221516280.1724-100000@iolanthe.rowland.org>
Date: Tue, 23 Oct 2012 16:42:02 +0800
Message-ID: <CACVXFVMzwUAmPn2rsALGTRcBN2w2MSVsbAMmJK4Pb_Cs5ksDcA@mail.gmail.com>
Subject: Re: [RFC PATCH v2 4/6] net/core: apply pm_runtime_set_memalloc_noio
 on network devices
From: Ming Lei <ming.lei@canonical.com>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: linux-kernel@vger.kernel.org, Oliver Neukum <oneukum@suse.de>,
        Minchan Kim <minchan@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "Rafael J. Wysocki" <rjw@sisk.pl>, Jens Axboe <axboe@kernel.dk>,
        "David S. Miller" <davem@davemloft.net>,
        Andrew Morton <akpm@linux-foundation.org>, netdev@vger.kernel.org,
        linux-usb@vger.kernel.org, linux-pm@vger.kernel.org,
        linux-mm@kvack.org, Eric Dumazet <eric.dumazet@gmail.com>,
        David Decotigny <david.decotigny@google.com>,
        Tom Herbert <therbert@google.com>, Ingo Molnar <mingo@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 23, 2012 at 3:18 AM, Alan Stern <stern@rowland.harvard.edu> wrote:
> On Mon, 22 Oct 2012, Ming Lei wrote:

> Is this really needed?  Even with iSCSI, doesn't register_disk() have
> to be called for the underlying block device?  And given your 3/6
> patch, wouldn't that mark the network device?

The problem is that network device is not one ancestor of the
iSCSI disk device, which transfers data over tcp stack.


Thanks,
--
Ming Lei
