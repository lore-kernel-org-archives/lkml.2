Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756868Ab2AKIFm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jan 2012 03:05:42 -0500
Received: from mail-yx0-f174.google.com ([209.85.213.174]:55627 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753157Ab2AKIFl convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jan 2012 03:05:41 -0500
MIME-Version: 1.0
In-Reply-To: <CAHGf_=odfZxYS+PcMfeJ2ddFm76+-KbOLNrjGBtoEdExdQmL3Q@mail.gmail.com>
References: <20120109181023.7c81d0be@annuminas.surriel.com>
 <4F0B7D1F.7040802@gmail.com> <4F0BABE0.8080107@redhat.com>
 <CAHGf_=qtpA5VTw5W0zaAhB2WCX1+-k59szTnDLnqDJeg+q9Jsw@mail.gmail.com> <CAHGf_=odfZxYS+PcMfeJ2ddFm76+-KbOLNrjGBtoEdExdQmL3Q@mail.gmail.com>
From: KOSAKI Motohiro <kosaki.motohiro@gmail.com>
Date: Wed, 11 Jan 2012 03:05:19 -0500
Message-ID: <CAHGf_=pnbOo6bGf3uxsCbn2YJ3XwpE79TDWdX2jRrUoE5Hkbdw@mail.gmail.com>
Subject: Re: [PATCH -mm] make swapin readahead skip over holes
To: Rik van Riel <riel@redhat.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        akpm@linux-foundation.org, Mel Gorman <mel@csn.ul.ie>,
        Johannes Weiner <hannes@cmpxchg.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2012/1/11 KOSAKI Motohiro <kosaki.motohiro@gmail.com>:
>> Also, I doubt current swap_cluster default is best value on nowadays.
>
> I meant, current average hdd spec is,
>  - average seek time: 8.5ms
>  - sequential access performance: about 60MB/sec
>
> so, we can eat free lunch up to 7MB ~= 60(MB/sec) * 1000 / 8.5(ms).

Bah! I'm moron.
the correct fomura is,

500KB = 60(MB/sec) / 1000(msec/ssec) *8.5 (ms)
