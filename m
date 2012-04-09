Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758095Ab2DIWob (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Apr 2012 18:44:31 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:62360 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752507Ab2DIWoa convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Apr 2012 18:44:30 -0400
MIME-Version: 1.0
In-Reply-To: <20120409222120.GA14149@kroah.com>
References: <CA+55aFwTFXtMLhXo7g9F7uyHc3W8SCw7z1gTm9jbWXM3Nqc_ZA@mail.gmail.com>
	<20120408195044.13ea6c8e.akpm@linux-foundation.org>
	<CA+55aFw7GsiZbNW84WVMUMT6C0Sw82jxaYxeaaB8qq=41Ep5Wg@mail.gmail.com>
	<alpine.DEB.2.00.1204090235350.14879@chino.kir.corp.google.com>
	<CA+55aFxUQJC+_aA0qnj0b-LoGfCjfFoG3HXgQ+7LND7y8dFDhw@mail.gmail.com>
	<alpine.DEB.2.00.1204091355280.10873@chino.kir.corp.google.com>
	<CAMbhsRRUNVn9_eL_obZxcZv7LqDW_8SeRApdKzDePbaW_Y4uvg@mail.gmail.com>
	<20120409222120.GA14149@kroah.com>
Date: Mon, 9 Apr 2012 15:44:28 -0700
X-Google-Sender-Auth: USoPO_02QPqgrfixSFGyEerEswY
Message-ID: <CANcMJZCAzixEDWpCDJyqqzSKjNka-JU1yu7ky+sgfQHBT+vkKA@mail.gmail.com>
Subject: Re: v3.4-rc2 out-of-memory problems (was Re: 3.4-rc1 sticks-and-crashs)
From: john stultz <johnstul@us.ibm.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Colin Cross <ccross@google.com>, David Rientjes <rientjes@google.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>, werner <w.landgraf@ru.ru>,
        Rik van Riel <riel@redhat.com>, Hugh Dickins <hughd@google.com>,
        linux-kernel@vger.kernel.org, Oleg Nesterov <oleg@redhat.com>,
        Rabin Vincent <rabin.vincent@stericsson.com>,
        Christian Bejram <christian.bejram@stericsson.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Anton Vorontsov <anton.vorontsov@linaro.org>, stable@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 9, 2012 at 3:21 PM, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
> On Mon, Apr 09, 2012 at 03:13:00PM -0700, Colin Cross wrote:
>> sched: Add a generic notifier when a task struct is about to be freed
>> https://www.codeaurora.org/gitweb/quic/la/?p=kernel/common.git;a=commitdiff;h=667dffa787a87ef4ea43cc65957ce96077fdcd0a
>
> Yes, I can't add a patch like that for this driver, that is why I
> thought everyone was getting together to "properly" determine how to
> solve this oom notifier problem.  Has that work stalled somwhere?

Anton Vorontsov  has been working on this (and just sent out some
related vmevent patches today). His hope is to use the vmevent  or mem
cgroup interface to notify a userland killer to get the same or
improved behavior as the in-kernel lowmemory killer.

thanks
-john
