Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753642Ab1JUIHK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Oct 2011 04:07:10 -0400
Received: from krak.alatek.krakow.pl ([46.170.108.42]:6572 "EHLO
	krak.alatek.krakow.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753604Ab1JUIHI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Oct 2011 04:07:08 -0400
From: Pawel Sikora <pluto@agmk.net>
To: Nai Xia <nai.xia@gmail.com>
Cc: Hugh Dickins <hughd@google.com>, arekm@pld-linux.org,
        Linus Torvalds <torvalds@linux-foundation.org>, linux-mm@kvack.org,
        Mel Gorman <mgorman@suse.de>, jpiszcz@lucidpixels.com,
        linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Andrea Arcangeli <aarcange@redhat.com>
Subject: Re: kernel 3.0: BUG: soft lockup: find_get_pages+0x51/0x110
Date: Fri, 21 Oct 2011 10:07:05 +0200
Message-ID: <2109011.boM0eZ0ZTE@pawels>
User-Agent: KMail/4.7.2 (Linux/3.0.6-2; KDE/4.7.2; x86_64; ; )
In-Reply-To: <CAPQyPG6d3Sv26SiR6Xj4S5xOOy2DmrwQYO2wAwzrcg=2A0EcMQ@mail.gmail.com>
References: <201110122012.33767.pluto@agmk.net> <CANsGZ6a6_q8+88FRV2froBsVEq7GhtKd9fRnB-0M2MD3a7tnSw@mail.gmail.com> <CAPQyPG6d3Sv26SiR6Xj4S5xOOy2DmrwQYO2wAwzrcg=2A0EcMQ@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 21 of October 2011 14:22:37 Nai Xia wrote:

> And as a side note. Since I notice that Pawel's workload may include OOM,

my last tests on patched (3.0.4 + migrate.c fix + vserver) kernel produce full cpu load
on dual 8-cores opterons like on this htop screenshot -> http://pluto.agmk.net/kernel/screen1.png
afaics all userspace applications usualy don't use more than half of physical memory
and so called "cache" on htop bar doesn't reach the 100%.

the patched kernel with disabled CONFIG_TRANSPARENT_HUGEPAGE (new thing in 2.6.38)
died at night, so now i'm going to disable also CONFIG_COMPACTION/MIGRATION in next
steps and stress this machine again...

