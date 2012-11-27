Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758624Ab2K0Iv1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Nov 2012 03:51:27 -0500
Received: from terminus.zytor.com ([198.137.202.10]:48352 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933252Ab2K0IvX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Nov 2012 03:51:23 -0500
Message-ID: <50B47EB7.20000@zytor.com>
Date: Tue, 27 Nov 2012 00:49:59 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Tang Chen <tangchen@cn.fujitsu.com>
CC: Bob Liu <lliubbo@gmail.com>, akpm@linux-foundation.org, rob@landley.net,
        isimatu.yasuaki@jp.fujitsu.com, laijs@cn.fujitsu.com,
        wency@cn.fujitsu.com, linfeng@cn.fujitsu.com, jiang.liu@huawei.com,
        yinghai@kernel.org, kosaki.motohiro@jp.fujitsu.com,
        minchan.kim@gmail.com, mgorman@suse.de, rientjes@google.com,
        rusty@rustcorp.com.au, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, linux-doc@vger.kernel.org
Subject: Re: [PATCH v2 0/5] Add movablecore_map boot option
References: <1353667445-7593-1-git-send-email-tangchen@cn.fujitsu.com> <CAA_GA1d7CxHvmZELvD_DO6u5tu1WBqfmLiuEzeFo=xMzuW50Tg@mail.gmail.com> <50B479FA.6010307@cn.fujitsu.com>
In-Reply-To: <50B479FA.6010307@cn.fujitsu.com>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/27/2012 12:29 AM, Tang Chen wrote:
> Another approach is like the following:
> movable_node = 1,3-5,8
> This could set all the memory on the nodes to be movable. And the rest
> of memory works as usual. But movablecore_map is more flexible.

... but *much* harder for users, so movable_node is better in most cases.

	-hpa

