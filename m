Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754558Ab1H3OgT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Aug 2011 10:36:19 -0400
Received: from a.ns.miles-group.at ([95.130.255.143]:38148 "EHLO radon.swed.at"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754153Ab1H3OgS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Aug 2011 10:36:18 -0400
Message-ID: <4E5CF55F.3040600@nod.at>
Date: Tue, 30 Aug 2011 16:36:15 +0200
From: Richard Weinberger <richard@nod.at>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:6.0) Gecko/20110812 Thunderbird/6.0
MIME-Version: 1.0
To: =?UTF-8?B?QW3DqXJpY28gV2FuZw==?= <xiyou.wangcong@gmail.com>
CC: linux-kernel@vger.kernel.org, viro@zeniv.linux.org.uk, dchinner@redhat.com,
        hch@lst.de
Subject: Re: [PATCH] ramfs: Remove module leftovers
References: <1314631491-27095-1-git-send-email-richard@nod.at> <CAM_iQpXWaYbooV_BX+ix8DzayFwhaACQTnwjbTuqmEV0fGU3=w@mail.gmail.com>
In-Reply-To: <CAM_iQpXWaYbooV_BX+ix8DzayFwhaACQTnwjbTuqmEV0fGU3=w@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am 30.08.2011 16:29, schrieb Américo Wang:
> On Mon, Aug 29, 2011 at 11:24 PM, Richard Weinberger<richard@nod.at>  wrote:
>> Since ramfs is hard-selected to "y", the module leftovers make
>> no sense.
>>
>> Signed-off-by: Richard Weinberger<richard@nod.at>
>
> Yeah, it makes sense to remove these module stuffs,
> but I think there is no need to make exit_ramfs_fs()
> be an __exit_call, so just remove exit_ramfs_fs()?

True. There no need to unregister ramfs.
I'll resend an updated patch!

Thanks,
//richard
