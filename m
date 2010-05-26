Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754866Ab0EZWJT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 May 2010 18:09:19 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:44034 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754095Ab0EZWJQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 May 2010 18:09:16 -0400
Date: Wed, 26 May 2010 23:14:48 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Peter Zijlstra <peterz@infradead.org>,
       Cornelia Huck <cornelia.huck@de.ibm.com>,
       Arve =?ISO-8859-14?B?SGr4bm5lduVn?= <arve@android.com>,
       linux-kernel@vger.kernel.org, Randy Dunlap <rdunlap@xenotime.net>,
       Andrew Morton <akpm@linux-foundation.org>,
       Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>,
       Jim Collar <jim.collar@eqware.net>,
       "Greg Kroah-Hartman" <gregkh@suse.de>, Avi Kivity <avi@redhat.com>,
       Len Brown <len.brown@intel.com>, Pavel Machek <pavel@ucw.cz>,
       Magnus Damm <damm@igel.co.jp>, Nigel Cunningham <nigel@tuxonice.net>,
       linux-doc@vger.kernel.org
Subject: Re: [PATCH 2/8] PM: suspend_block: Add driver to access suspend
 blockers from user-space
Message-ID: <20100526231448.41c5be7f@lxorguk.ukuu.org.uk>
In-Reply-To: <201005262357.28933.rjw@sisk.pl>
References: <1274482015-30899-1-git-send-email-arve@android.com>
	<1274482015-30899-3-git-send-email-arve@android.com>
	<1274863428.5882.4860.camel@twins>
	<201005262357.28933.rjw@sisk.pl>
Followup-To: linux-pm@lists.linux-foundation.org
X-Mailer: Claws Mail 3.7.5 (GTK+ 2.18.9; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> This whole thing is related to the statistics part, which Arve says is
> essential to him.  He wants to collect statistics for each suspend blocker
> activated and deactivated so that he can tell who's causing problems by
> blocking suspend too often.  The name also is a part of this.

If he wants to collect stats about misbehaving code then presumably he
needs reliable stats. Arbitary user set names are not reliable and
judging by app vendor behaviour in the proprietary space with other such
examples they will actively name their blockers in a manner specifically
intended to hide the cause so as to 'reduce support costs'.

Its a waste of memory (especially if I create a million of them with a
long name for fun).

It's all an economic system, proprietary app vendors are in it to make
money, some will therefore game the system and the rest will be forced to
follow to keep their playing field fair.

Alan
