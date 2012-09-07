Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760122Ab2IGGa6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Sep 2012 02:30:58 -0400
Received: from mail-ob0-f174.google.com ([209.85.214.174]:36288 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755097Ab2IGGa4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Sep 2012 02:30:56 -0400
MIME-Version: 1.0
In-Reply-To: <20120907123348.798dfc28@notabene.brown>
References: <CAOHz1948UduxDDvpA33T9BaM4QoMpwF1wAQKjY3UgSSOOy6k8g@mail.gmail.com>
	<20120907123348.798dfc28@notabene.brown>
Date: Fri, 7 Sep 2012 14:30:56 +0800
Message-ID: <CAOHz195Bhfs5Rx-qd2BmO8N4cqrdjCXDuXwF5QjNf6mVSS9Y8g@mail.gmail.com>
Subject: Re: Content Of Files May Be Changed After One Disk Is Failed In RAID5
From: clplayer <cl.player@gmail.com>
To: NeilBrown <neilb@suse.de>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> --assume-clean is not safe with RAID5 unless the array actually is clean.
> It is safe with RAID1 and RAID6 due to details of the specific implementation.
> So I suspect that is the cause of the corruption.
>
> NeilBrown
>

Thank you for the information.

I have removed --assume-clean in the script and executed the stress
after that raid5 completed resync.

The files are all consistent in the rest tests.

I am now wondering, what's different between the implementation of
raid5 algorithm and of raid6 algorithm?

Would you please suggest some hints in the implementation?

Thank you,
Peng.
