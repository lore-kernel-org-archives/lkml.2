Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758187Ab0DGRML (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Apr 2010 13:12:11 -0400
Received: from smtp-out.google.com ([74.125.121.35]:10465 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757863Ab0DGRMH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Apr 2010 13:12:07 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=mime-version:in-reply-to:references:date:message-id:subject:from:to:
	cc:content-type:x-system-of-record;
	b=CdIWQdN56bF+4cQ1LrjTi8F4kpCSLvJaLKqM+MKT96Audg/VGBSbCY8jpNK39DcSG
	l3UTaXccIpjYIqj7jMArA==
MIME-Version: 1.0
In-Reply-To: <4BAB027D.7000405@cn.fujitsu.com>
References: <4B8DFFD7.2000908@cn.fujitsu.com>
	 <20100303154748.GC2866@redhat.com>
	 <e98e18941003031519v14d4f79cg33da5c3cf1f5ac03@mail.gmail.com>
	 <1786ab031003031825m5467c86jf5c355df10001dd2@mail.gmail.com>
	 <4B8F27BD.2020704@cn.fujitsu.com> <4B8F62B7.3080401@cn.fujitsu.com>
	 <20100304152400.GB18786@redhat.com> <4B906BB6.3080104@cn.fujitsu.com>
	 <20100305141300.GA3296@redhat.com> <4BAB027D.7000405@cn.fujitsu.com>
Date: Wed, 7 Apr 2010 10:12:03 -0700
Message-ID: <i2o1786ab031004071012t51ae0a10t3b4f30bece40d8a6@mail.gmail.com>
Subject: Re: [PATCH 1/2 V3] io-controller: Add a new interface "weight_device" 
	for IO-Controller
From: Chad Talbott <ctalbott@google.com>
To: Gui Jianfeng <guijianfeng@cn.fujitsu.com>
Cc: jens.axboe@oracle.com, Vivek Goyal <vgoyal@redhat.com>,
       linux-kernel@vger.kernel.org, Nauman Rafique <nauman@google.com>,
       Li Zefan <lizf@cn.fujitsu.com>, Divyesh Shah <dpshah@google.com>
Content-Type: text/plain; charset=ISO-8859-1
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 24, 2010 at 11:28 PM, Gui Jianfeng
<guijianfeng@cn.fujitsu.com> wrote:
> Vivek Goyal wrote:
>> On Fri, Mar 05, 2010 at 10:25:58AM +0800, Gui Jianfeng wrote:
>>> V2->V3 changes:
>>> - Move policy_*_node() functions up to get rid of forward declarations
>>> - rename related functions by adding prefix "blkio_"
>>>
>>
>> Thanks for the changes Gui. Looks good to me.
>>
>> Acked-by: Vivek Goyal <vgoyal@redhat.com>
>
> Hi Jens,
>
> This patchset seems to get lost. Just for reminding. Any comments?

Hi Jens,

Just want to add a quick note that we're excited about this
functionality and are hoping to see it go in.

Chad
