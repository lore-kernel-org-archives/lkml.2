Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762680Ab0HGNjx (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Aug 2010 09:39:53 -0400
Received: from mx1.redhat.com ([209.132.183.28]:24730 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762655Ab0HGNjw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Aug 2010 09:39:52 -0400
Message-ID: <4C5D61E7.9090008@redhat.com>
Date: Sat, 07 Aug 2010 09:38:47 -0400
From: Eric Sandeen <sandeen@redhat.com>
User-Agent: Thunderbird 2.0.0.24 (Macintosh/20100228)
MIME-Version: 1.0
To: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
CC: Greg KH <greg@kroah.com>, Stefan Bader <stefan.bader@canonical.com>,
        Greg KH <gregkh@suse.de>, linux-kernel@vger.kernel.org,
        stable@kernel.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, stable-review@kernel.org,
        alan@lxorguk.ukuu.org.uk
Subject: Re: [stable] [Stable-review] [116/165] ext4: dont return to userspace
 after freezing the fs with a mutex held
References: <20100730171510.105264205@clark.site> <4C56B45E.9010601@canonical.com> <4C56FA35.7060607@redhat.com> <20100802184806.GA16878@kroah.com> <20100807040732.GB16342@khazad-dum.debian.net>
In-Reply-To: <20100807040732.GB16342@khazad-dum.debian.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Henrique de Moraes Holschuh wrote:
> On Mon, 02 Aug 2010, Greg KH wrote:
>> On Mon, Aug 02, 2010 at 12:02:45PM -0500, Eric Sandeen wrote:
>>> On 08/02/2010 07:04 AM, Stefan Bader wrote:
>>>> We have reports about this patch breaking lvm snapshhots. Eric, there is a patch
>>>> mentioned which is supposed to fix things but its not upstream, yet.
>>>> Do you know what happened to that?
>>> right, patch below is needed to fix things.
>>>
>>> Ted just acked it on the list recently; Greg, I'd either drop 116/165
>>> for now, or include the patch below which should be upstream soon...
>> I can't take anything that isn't upstream yet.
>>
>> And I just released with this patch in the kernel, should I do a revert
>> and do a new release?
> 
> Any answers on this?
> 

Yes, I'd revert it for now, I'm afraid, if the other patch isn't upstream
yet.

Sorry about that,

-Eric
