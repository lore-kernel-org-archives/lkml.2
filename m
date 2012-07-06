Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756802Ab2GFKJk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jul 2012 06:09:40 -0400
Received: from mail9.hitachi.co.jp ([133.145.228.44]:37851 "EHLO
	mail9.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756664Ab2GFKJi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jul 2012 06:09:38 -0400
X-Greylist: delayed 84376 seconds by postgrey-1.27 at vger.kernel.org; Fri, 06 Jul 2012 06:09:38 EDT
X-AuditID: b753bd60-9a0f2ba000000f6c-87-4ff6b9609fc3
X-AuditID: b753bd60-9a0f2ba000000f6c-87-4ff6b9609fc3
Message-ID: <4FF6B94B.60204@hitachi.com>
Date: Fri, 06 Jul 2012 19:09:15 +0900
From: HAYASAKA Mitsuo <mitsuo.hayasaka.hu@hitachi.com>
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:11.0) Gecko/20120327 Thunderbird/11.0.1
MIME-Version: 1.0
To: Nikolaus Rath <Nikolaus@rath.org>
Cc: Miklos Szeredi <miklos@szeredi.hu>, fuse-devel@lists.sourceforge.net,
        linux-kernel@vger.kernel.org, yrl.pp-manager.tt@hitachi.com
Subject: Re: [RFC PATCH 0/5] fuse: make maximum read/write request size tunable
References: <20120705105017.17812.95542.stgit@ltc137.sdl.hitachi.co.jp> <87vci2gxzr.fsf@inspiron.ap.columbia.edu>
In-Reply-To: <87vci2gxzr.fsf@inspiron.ap.columbia.edu>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Nikolaus,

Thank you for your comments.

(2012/07/05 22:04), Nikolaus Rath wrote:
> Mitsuo Hayasaka<mitsuo.hayasaka.hu@hitachi.com>  writes:
>> Hi,
>>
>> This patch series make maximum read/write request size tunable in FUSE.
>> Currently, it is limited to FUSE_MAX_PAGES_PER_REQ which is equal
>> to 32 pages. It is required to change it in order to improve the
>> throughput since optimized value depends on various factors such
>> as type and version of local filesystems used and HW specs, etc.
>
> This truly is a joyful week for FUSE :-).
>
> Are these patches compatible with the fuse write-back patch series
> posted by Pavel a few days ago?


I applied this patch series to the latest upstream kernel and measured
the read/write throughput using it. So, I have not try Pavel's patch yet.

However, I think it is compatible with his write-back patch series
since it just makes maximum limit of fuse request size tunable.
And my patch will be effective even for direct I/O.

Thanks,

>
>
> Thanks,
>
>     -Nikolaus
>

