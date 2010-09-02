Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752228Ab0IBFox (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Sep 2010 01:44:53 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:62364 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751762Ab0IBFow (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Sep 2010 01:44:52 -0400
Message-ID: <4C7F39B3.4000901@cn.fujitsu.com>
Date: Thu, 02 Sep 2010 13:44:19 +0800
From: Miao Xie <miaox@cn.fujitsu.com>
Reply-To: miaox@cn.fujitsu.com
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100413 Fedora/3.0.4-2.fc13 Thunderbird/3.0.4
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>
CC: Ingo Molnar <mingo@redhat.com>, Andrew Morton <akpm@linux-foundation.org>,
        Chris Mason <chris.mason@oracle.com>, "Theodore Ts'o" <tytso@mit.edu>,
        Andreas Dilger <adilger.kernel@dilger.ca>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Linux Btrfs <linux-btrfs@vger.kernel.org>,
        Linux Ext4 <linux-ext4@vger.kernel.org>
Subject: Re: [PATCH 1/3] lib: introduce some memory copy macros and functions
References: <4C7E2CA9.9060702@cn.fujitsu.com> <1283354736.2059.1206.camel@laptop>
In-Reply-To: <1283354736.2059.1206.camel@laptop>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 01 Sep 2010 17:25:36 +0200, Peter Zijlstra wrote:
> On Wed, 2010-09-01 at 18:36 +0800, Miao Xie wrote:
>> + * This program is free software; you can redistribute it and/or modify it
>> + * under the terms of the GNU General Public License as published by the Free
>> + * Software Foundation; either version 2.1 of the License, or (at your option)
>> + * any later version.
>
> The kernel is GPL v2, see COPYING. GPL v2.1 is not a suitable license.

Ok, I will change it.

Thanks
Miao

