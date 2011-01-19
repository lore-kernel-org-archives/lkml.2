Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753275Ab1ASBY4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Jan 2011 20:24:56 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:50405 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1753109Ab1ASBYz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Jan 2011 20:24:55 -0500
Message-ID: <4D363D7D.1060705@cn.fujitsu.com>
Date: Wed, 19 Jan 2011 09:25:17 +0800
From: Gui Jianfeng <guijianfeng@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.24 (Windows/20100228)
MIME-Version: 1.0
To: Vivek Goyal <vgoyal@redhat.com>
CC: Jens Axboe <axboe@kernel.dk>,
        linux kernel mailing list <linux-kernel@vger.kernel.org>,
        Corrado Zoccolo <czoccolo@gmail.com>,
        Chad Talbott <ctalbott@google.com>, Nauman Rafique <nauman@google.com>,
        Divyesh Shah <dpshah@google.com>, jmoyer@redhat.com,
        Shaohua Li <shaohua.li@intel.com>
Subject: Re: [PATCH 2/6 v3] cfq-iosched: Introduce cfq_entity for CFQ group
References: <4D180ECE.4000305@cn.fujitsu.com> <4D18536B.9090109@cn.fujitsu.com> <20110118212056.GK27946@redhat.com>
In-Reply-To: <20110118212056.GK27946@redhat.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2011-01-19 09:24:22,
	Serialize by Router on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2011-01-19 09:24:23,
	Serialize complete at 2011-01-19 09:24:23
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Vivek Goyal wrote:
> On Mon, Dec 27, 2010 at 04:50:51PM +0800, Gui Jianfeng wrote:
> 
> [..]
>> -static struct cfq_group *cfq_rb_first_group(struct cfq_rb_root *root)
>> +static struct cfq_entity *cfq_rb_first_entity(struct cfq_rb_root *root)
>>  {
>>  	if (!root->left)
>>  		root->left = rb_first(&root->rb);
>>  
>>  	if (root->left)
>> -		return rb_entry_cfqg(root->left);
>> +		return rb_entry_entity(root->left);
>>  
> 
> Why are we defining cfq_rb_first_entity(). Can't we simply use cfq_rb_first()
> as introduced in first patch.

Ok, Will rename it.

Thanks,
Gui

> 
> Thanks
> Vivek
> 
