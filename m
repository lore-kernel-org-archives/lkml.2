Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753118Ab2F0Pty (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jun 2012 11:49:54 -0400
Received: from natasha.panasas.com ([67.152.220.90]:35362 "EHLO
	natasha.panasas.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750887Ab2F0Ptx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jun 2012 11:49:53 -0400
Message-ID: <4FEB2B8D.7070909@panasas.com>
Date: Wed, 27 Jun 2012 18:49:33 +0300
From: Boaz Harrosh <bharrosh@panasas.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:8.0) Gecko/20111113 Thunderbird/8.0
MIME-Version: 1.0
To: <dedekind1@gmail.com>
CC: Al Viro <viro@ZenIV.linux.org.uk>,
        Linux FS Maling List <linux-fsdevel@vger.kernel.org>,
        Linux Kernel Maling List <linux-kernel@vger.kernel.org>,
        Benny Halevy <bhalevy@tonian.com>, <osd-dev@open-osd.org>
Subject: Re: [PATCH] exofs: stop using s_dirt
References: <1338810507-26539-1-git-send-email-dedekind1@gmail.com> <1340281745.13910.211.camel@sauron.fi.intel.com>
In-Reply-To: <1340281745.13910.211.camel@sauron.fi.intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/21/2012 03:29 PM, Artem Bityutskiy wrote:

> On Mon, 2012-06-04 at 14:48 +0300, Artem Bityutskiy wrote:
>> From: Artem Bityutskiy <artem.bityutskiy@linux.intel.com>
>>
>> Exofs has the '->write_super()' handler and makes some use of the '->s_dirt'
>> superblock flag, but it really needs neither of them because it never sets
>> 's_dirt' to one which means the VFS never calls its '->write_super()' handler.
>> Thus, remove both.
>>
>> Note, I am trying to remove both 's_dirt' and 'write_super()' from VFS
>> altogether once all users are gone.
>>
>> Signed-off-by: Artem Bityutskiy <artem.bityutskiy@linux.intel.com>
> 
> Al or Boaz, would you please consider picking this patch?
> 


I will

Sorry for the delay was sick and am only now coming back on.

It should all be included for the next merge window.

Thanks for doing this.
Boaz
