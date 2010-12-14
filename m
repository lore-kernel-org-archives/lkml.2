Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758969Ab0LNBr2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Dec 2010 20:47:28 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:52234 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1758947Ab0LNBr0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Dec 2010 20:47:26 -0500
Message-ID: <4D06CCC2.9020608@cn.fujitsu.com>
Date: Tue, 14 Dec 2010 09:47:46 +0800
From: Gui Jianfeng <guijianfeng@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.24 (Windows/20100228)
MIME-Version: 1.0
To: Vivek Goyal <vgoyal@redhat.com>
CC: Jens Axboe <axboe@kernel.dk>, Corrado Zoccolo <czoccolo@gmail.com>,
        Chad Talbott <ctalbott@google.com>, Nauman Rafique <nauman@google.com>,
        Divyesh Shah <dpshah@google.com>,
        linux kernel mailing list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/8 v2] cfq-iosched: Introduce cfq_entity for CFQ group
References: <4CDF7BC5.9080803@cn.fujitsu.com> <4CDF9CC6.2040106@cn.fujitsu.com> <20101115165319.GI30792@redhat.com> <4CE2718C.6010406@kernel.dk> <4D01C6AB.9040807@cn.fujitsu.com> <4D057A81.1000901@cn.fujitsu.com> <20101213165925.GF20454@redhat.com>
In-Reply-To: <20101213165925.GF20454@redhat.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2010-12-14 09:47:22,
	Serialize by Router on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2010-12-14 09:47:25,
	Serialize complete at 2010-12-14 09:47:25
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Vivek Goyal wrote:
> On Mon, Dec 13, 2010 at 09:44:33AM +0800, Gui Jianfeng wrote:
>> Introduce cfq_entity for CFQ group
>>
>> Signed-off-by: Gui Jianfeng <guijianfeng@cn.fujitsu.com>
>> ---
>>  block/cfq-iosched.c |  113 ++++++++++++++++++++++++++++++--------------------
>>  1 files changed, 68 insertions(+), 45 deletions(-)
>>
>> diff --git a/block/cfq-iosched.c b/block/cfq-iosched.c
>> index 9b07a24..91e9833 100644
>> --- a/block/cfq-iosched.c
>> +++ b/block/cfq-iosched.c
>> @@ -1,5 +1,5 @@
>>  /*
>> - *  CFQ, or complete fairness queueing, disk scheduler.
>> + *  Cfq, or complete fairness queueing, disk scheduler.
> 
> Is this really required?

Strange... I don't rember I do this change. Must be some misoperation.

Gui
