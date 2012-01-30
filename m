Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754005Ab2A3CYb (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Jan 2012 21:24:31 -0500
Received: from cantor2.suse.de ([195.135.220.15]:50066 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752368Ab2A3CYa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Jan 2012 21:24:30 -0500
Date: Sun, 29 Jan 2012 18:22:42 -0800
From: Greg KH <gregkh@suse.de>
To: Anton Vorontsov <anton.vorontsov@linaro.org>
Cc: Arve =?iso-8859-1?B?SGr4bm5lduVn?= <arve@android.com>,
        KOSAKI Motohiro <kosaki.motohiro@gmail.com>,
        San Mehat <san@google.com>, Colin Cross <ccross@android.com>,
        Oleg Nesterov <oleg@redhat.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        linux-kernel@vger.kernel.org, kernel-team@android.com,
        linaro-kernel@lists.linaro.org
Subject: Re: [PATCH 1/3] procfs: Export next_tgid(), move it to kernel/pid.c
Message-ID: <20120130022242.GA5805@suse.de>
References: <20120130011323.GA30274@oksana.dev.rtsoft.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120130011323.GA30274@oksana.dev.rtsoft.ru>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 30, 2012 at 05:13:23AM +0400, Anton Vorontsov wrote:
> We'd like to use this function in the android low memory killer driver, so
> let's export it.

Why is it needed?

I _REALLY_ don't want to add any exports to any part of the kernel for
the android low memory stuff.  That is because it is not something that
should be touching anything else, especially as numerous people disagree
with what it does and how it does it.

Instead, you should be spending the time and effort to properly
implement this, as has been discussed numerous times, the last one a
mere few weeks ago when someone tried adding the nokia-specific low
memory killer/notifier code.

So no, sorry, I will not take these patches, unless you come up with
some very good justifications why.

greg k-h
