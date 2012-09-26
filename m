Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753792Ab2IZAeS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Sep 2012 20:34:18 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:33751 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751593Ab2IZAeQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Sep 2012 20:34:16 -0400
X-SecurityPolicyCheck: OK by SHieldMailChecker v1.7.4
Message-ID: <50624D5F.9050008@jp.fujitsu.com>
Date: Wed, 26 Sep 2012 09:33:35 +0900
From: Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:15.0) Gecko/20120907 Thunderbird/15.0.1
MIME-Version: 1.0
To: Dan Carpenter <dan.carpenter@oracle.com>
CC: <x86@kernel.org>, <linux-mm@kvack.org>, <linux-kernel@vger.kernel.org>
Subject: Re: hot-added cpu is not asiggned to the correct node
References: <50501E97.2020200@jp.fujitsu.com> <20120924093312.GC28937@mwanda>
In-Reply-To: <20120924093312.GC28937@mwanda>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Dan,

At first, thank you for your comment.

2012/09/24 18:33, Dan Carpenter wrote:
> On Wed, Sep 12, 2012 at 02:33:11PM +0900, Yasuaki Ishimatsu wrote:
>> When I hot-added CPUs and memories simultaneously using container driver,
>> all the hot-added CPUs were mistakenly assigned to node0.
>>
>
> Is this something which used to work correctly?  If so which was the
> most recent working kernel?

The cpu hot-adding is first time on my x86 box. So I don't know
whether old kernel can work well or not. But it seems that x86
does not permit to create memory-less-node. So I guess the problem
occurs on old kernel.

Thanks,
Yasuaki Ishimatsu

> regards,
> dan carpenter
>


