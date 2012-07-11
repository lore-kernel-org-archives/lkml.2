Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758465Ab2GKX5J (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jul 2012 19:57:09 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:59003 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753425Ab2GKX5H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jul 2012 19:57:07 -0400
Date: Wed, 11 Jul 2012 16:57:06 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Cc: Randy Dunlap <rdunlap@xenotime.net>, linux-kernel@vger.kernel.org,
        "devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-next@vger.kernel.org, Mike Lockwood <lockwood@android.com>,
        Andrzej Pietrasiewicz <andrzej.p@samsung.com>
Subject: Re: mmotm 2012-07-10-16-59 uploaded (staging/ccg)
Message-Id: <20120711165706.68a9ad39.akpm@linux-foundation.org>
In-Reply-To: <1342049894.18004.98.camel@haakon2.linux-iscsi.org>
References: <20120711000148.BAD1E5C0050@hpza9.eem.corp.google.com>
	<4FFDF7BC.6050602@xenotime.net>
	<20120711151644.23016bd8.akpm@linux-foundation.org>
	<1342049894.18004.98.camel@haakon2.linux-iscsi.org>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 11 Jul 2012 16:38:14 -0700
"Nicholas A. Bellinger" <nab@linux-iscsi.org> wrote:

> I certainly won't attempt to defend this particular piece of code, but
> FYI the original design limitation(s) for usb-gadget that requires this
> type of strangeness was elaborated by Sebastian a few months back here:
> 
> http://www.spinics.net/lists/target-devel/msg02374.html

hm.  I see.  Thanks.  I think.  erk.  Didn't know that.

The more drivers we add, the harder this is to fix :(
