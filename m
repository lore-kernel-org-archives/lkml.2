Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933425Ab1KIAPS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Nov 2011 19:15:18 -0500
Received: from mail-bw0-f46.google.com ([209.85.214.46]:55160 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754063Ab1KIAPQ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Nov 2011 19:15:16 -0500
MIME-Version: 1.0
In-Reply-To: <1320777783.14409.397.camel@x61.thuisdomein>
References: <1320767771.14409.389.camel@x61.thuisdomein> <CAMjpGUcw-oTat82ETiZXiEWtoG72PZGPVTC_6-fQL4J4D0uQpg@mail.gmail.com>
 <1320777783.14409.397.camel@x61.thuisdomein>
From: Mike Frysinger <vapier.adi@gmail.com>
Date: Tue, 8 Nov 2011 19:14:54 -0500
Message-ID: <CAMjpGUd9PSOHHP-TFRx+mwzjKdo1aLt9JjOh1o39ym-xya+rKA@mail.gmail.com>
Subject: Re: [PATCH] [TRIVIAL] Blackfin: remove bfin_simple_timer.h
To: Paul Bolle <pebolle@tiscali.nl>
Cc: linux-kernel@vger.kernel.org, Jiri Kosina <trivial@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 8, 2011 at 13:43, Paul Bolle wrote:
> On Tue, 2011-11-08 at 13:07 -0500, Mike Frysinger wrote:
>> there is a driver that is out of tree that uses it, but we haven't
>> gotten cleaned up for merging.  the header should have been kept as
>> part of that merge, but i imagine the initial Blackfin support was a
>> bit hectic (as are all initial arch ports) so it was accidentally
>> included.
>
> So this header can be removed, can't it?

if we do remove it, it'll be via the Blackfin tree
-mike
