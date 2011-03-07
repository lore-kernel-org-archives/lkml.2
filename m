Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754462Ab1CGI2J (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Mar 2011 03:28:09 -0500
Received: from 0122700014.0.fullrate.dk ([95.166.99.235]:43542 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753963Ab1CGI2G (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Mar 2011 03:28:06 -0500
Message-ID: <4D749714.60306@kernel.dk>
Date: Mon, 07 Mar 2011 09:28:04 +0100
From: Jens Axboe <axboe@kernel.dk>
MIME-Version: 1.0
To: Gui Jianfeng <guijianfeng@cn.fujitsu.com>
CC: Vivek Goyal <vgoyal@redhat.com>, lkml <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] cfq-iosched: Fix update_vdisktime logic
References: <4D3E4317.80406@cn.fujitsu.com> <20110125212656.GF10664@redhat.com> <4D743667.70807@cn.fujitsu.com>
In-Reply-To: <4D743667.70807@cn.fujitsu.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2011-03-07 02:35, Gui Jianfeng wrote:
> Vivek Goyal wrote:
>> On Tue, Jan 25, 2011 at 11:27:19AM +0800, Gui Jianfeng wrote:
>>> The update_vdisktime logic is broken since commit b54ce60eb7f61f8e314b8b241b0469eda3bb1d42,
>>> st->min_vdisktime never makes a progress. Fix it.
>>>
>>> Thanks Vivek for pointing it out.
>>>
>>> Signed-off-by: Gui Jianfeng <guijianfen@cn.fujitsu.com>
>>
>> Thanks Gui. Looks good to me.
>>
>> Acked-by: Vivek Goyal <vgoyal@redhat.com>
> 
> Jens, Would you pick up this fix?

Done, applied. Thanks.

-- 
Jens Axboe

