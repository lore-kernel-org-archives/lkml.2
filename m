Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753487Ab0IBHRn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Sep 2010 03:17:43 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:50822 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751131Ab0IBHRm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Sep 2010 03:17:42 -0400
Message-ID: <4C7F4F76.1040208@cn.fujitsu.com>
Date: Thu, 02 Sep 2010 15:17:10 +0800
From: Miao Xie <miaox@cn.fujitsu.com>
Reply-To: miaox@cn.fujitsu.com
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100413 Fedora/3.0.4-2.fc13 Thunderbird/3.0.4
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        "Theodore Ts'o" <tytso@mit.edu>,
        Andreas Dilger <adilger.kernel@dilger.ca>,
        Chris Mason <chris.mason@oracle.com>, Yan Zheng <zheng.yan@oracle.com>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Linux Btrfs <linux-btrfs@vger.kernel.org>,
        Linux Ext4 <linux-ext4@vger.kernel.org>
Subject: Re: [PATCH V2 0/3] improve the performance of some memory copy functions
References: <4C7F3A26.6020607@cn.fujitsu.com> <20100902065347.GA29972@elte.hu>
In-Reply-To: <20100902065347.GA29972@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2 Sep 2010 08:53:47 +0200, Ingo Molnar wrote:
>
> * Miao Xie<miaox@cn.fujitsu.com>  wrote:
>
>> - change the version of GPL from version 2.1 to version 2
>
> How were you able to do this? If the code derives from glibc (as your
> comments in the patches suggest), and if glibc is under the GPL v2.1,
> then you probably cannot simply change the license to v2.

I think we can do it, because the orignal code is under LGPL v2.1,
LGPL v2.1 permits us to apply the terms of the ordinary GNU General Public
License instead of it.

This is the clause of LGPL v2.1:
3. You may opt to apply the terms of the ordinary GNU General Public
License instead of this License to a given copy of the Library. To do
this, you must alter all the notices that refer to this License, so
that they refer to the ordinary GNU General Public License, version 2,
instead of to this License. (If a newer version than version 2 of the
ordinary GNU General Public License has appeared, then you can specify
that version instead if you wish.) Do not make any other change in these
notices.

Once this change is made in a given copy, it is irreversible for that copy,
so the ordinary GNU General Public License applies to all subsequent copies
and derivative works made from that copy.

This option is useful when you wish to copy part of the code of the Library
into a program that is not a library.

The following is the URL of LGPL v2.1:
   http://www.gnu.org/licenses/old-licenses/lgpl-2.1.html

Thanks
Miao
