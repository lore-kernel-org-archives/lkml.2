Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756004Ab0HaAe5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Aug 2010 20:34:57 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:56321 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1755817Ab0HaAe4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Aug 2010 20:34:56 -0400
Message-ID: <4C7C4E42.9070109@cn.fujitsu.com>
Date: Tue, 31 Aug 2010 08:35:14 +0800
From: Gui Jianfeng <guijianfeng@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.24 (Windows/20100228)
MIME-Version: 1.0
To: Chad Talbott <ctalbott@google.com>
CC: Vivek Goyal <vgoyal@redhat.com>, Jens Axboe <axboe@kernel.dk>,
        Jeff Moyer <jmoyer@redhat.com>, Divyesh Shah <dpshah@google.com>,
        Corrado Zoccolo <czoccolo@gmail.com>,
        Nauman Rafique <nauman@google.com>,
        linux kernel mailing list <linux-kernel@vger.kernel.org>
Subject: Re: [RFC] [PATCH] cfq-iosched: add cfq group hierarchical scheduling
 support
References: <4C7B54C0.7080008@cn.fujitsu.com> <AANLkTinCW-U2aOUh7yHM3mBdKAdeGiY-MvbvowFe5p-j@mail.gmail.com>
In-Reply-To: <AANLkTinCW-U2aOUh7yHM3mBdKAdeGiY-MvbvowFe5p-j@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Chad Talbott wrote:
> On Sun, Aug 29, 2010 at 11:50 PM, Gui Jianfeng
> <guijianfeng@cn.fujitsu.com> wrote:
>>  o Each cfq group has its own group service tree.
>>  o Each cfq group contains a "group schedule entity" (gse) that
>>    schedules on parent cfq group's service tree.
>>  o Each cfq group contains a "queue schedule entity"(qse), it
>>    represents all cfqqs located on this cfq group. It schedules
>>    on this group's service tree. For the time being, root group
>>    qse's weight is 1000, and subgroup qse's weight is 500.
>>  o All gses and qse which belones to a same cfq group schedules
>>    on the same group service tree.
> 
> Overall, I like this approach.  It's similar to what we are using with
> earlier hierarchical patches.  Can you improve the naming a little
> bit?  "qse" and "gse" look almost identical and breaks my brain.
> Maybe "queue_entity" and "group_entity"?  If entity is to much to
> type, then "item"?

Thanks for reviewing Chad.
I will modify the name.

Thanks,
Gui

> 
> Chad
> 
> 
