Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753014Ab2A3Ntg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jan 2012 08:49:36 -0500
Received: from mx1.redhat.com ([209.132.183.28]:42607 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752630Ab2A3Ntf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jan 2012 08:49:35 -0500
Date: Mon, 30 Jan 2012 14:43:12 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Anton Vorontsov <anton.vorontsov@linaro.org>
Cc: Arve =?iso-8859-1?B?SGr4bm5lduVn?= <arve@android.com>,
        KOSAKI Motohiro <kosaki.motohiro@gmail.com>,
        Greg Kroah-Hartman <gregkh@suse.de>, San Mehat <san@google.com>,
        Colin Cross <ccross@android.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        linux-kernel@vger.kernel.org, kernel-team@android.com,
        linaro-kernel@lists.linaro.org
Subject: Re: [PATCH 1/3] procfs: Export next_tgid(), move it to kernel/pid.c
Message-ID: <20120130134312.GA14110@redhat.com>
References: <20120130011323.GA30274@oksana.dev.rtsoft.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120130011323.GA30274@oksana.dev.rtsoft.ru>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/30, Anton Vorontsov wrote:
>
> We'd like to use this function in the android low memory killer driver, so
> let's export it.

I guess you mean 3/3.

If lowmem_shrink() can use next_tid() which is not really accurate,
then why tou can't simply change it to use rcu_read_lock ?

Oleg.

