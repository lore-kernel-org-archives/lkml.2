Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755268Ab2LCCos (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Dec 2012 21:44:48 -0500
Received: from ozlabs.org ([203.10.76.45]:48576 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754467Ab2LCCoj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Dec 2012 21:44:39 -0500
From: Rusty Russell <rusty@rustcorp.com.au>
To: sat <takeuchi_satoru@jp.fujitsu.com>, lkml <linux-kernel@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Masaki Kimura <masaki.kimura.kz@hitachi.com>
Subject: Re: [PATCH] module: Remove a extra null character at the top of module->strtab.
In-Reply-To: <50B56769.3080501@jp.fujitsu.com>
References: <50B56769.3080501@jp.fujitsu.com>
User-Agent: Notmuch/0.14 (http://notmuchmail.org) Emacs/23.4.1 (i686-pc-linux-gnu)
Date: Mon, 03 Dec 2012 12:37:45 +1030
Message-ID: <87sj7nj3bi.fsf@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

sat <takeuchi_satoru@jp.fujitsu.com> writes:
> From: Satoru Takeuchi <takeuchi_satoru@jp.fujitsu.com>
>
> There is a extra null character('\0') at the top of module->strtab for
> each module. Commit 59ef28b introduced this bug and this patch fixes it.

Hi Satoru!

        Unfortunately I took a week off last week, and when I read my
mail I read your previous report first, and created the fix myself.

I have now discarded my fix, and applied your identical one; you were
first, after all!

Thanks,
Rusty.
