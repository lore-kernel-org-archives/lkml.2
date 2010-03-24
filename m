Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752080Ab0CXFQK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Mar 2010 01:16:10 -0400
Received: from crca.org.au ([74.207.252.120]:38983 "EHLO crca.org.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751561Ab0CXFQI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Mar 2010 01:16:08 -0400
X-Bogosity: Ham, spamicity=0.000000
Message-ID: <4BA9A048.6050705@crca.org.au>
Date: Wed, 24 Mar 2010 16:16:56 +1100
From: Nigel Cunningham <ncunningham@crca.org.au>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9pre) Gecko/20100301 Shredder/3.0.4pre
MIME-Version: 1.0
To: Josef Bacik <josef@redhat.com>
CC: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
       chris.mason@oracle.com, viro@ZenIV.linux.org.uk, hch@lst.de
Subject: Re: [PATCH] Introduce freeze_super and thaw_super for the fsfreeze
 ioctl
References: <20100323142200.GA2381@localhost.localdomain> <4BA93FE3.9020502@crca.org.au> <20100324011714.GA5658@localhost.localdomain>
In-Reply-To: <20100324011714.GA5658@localhost.localdomain>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi.

On 24/03/10 12:17, Josef Bacik wrote:
> On Wed, Mar 24, 2010 at 09:25:39AM +1100, Nigel Cunningham wrote:
>> Hi.
>>
>> A cc would have been nice :)
>>
>> Thankfully the subject caught my eye.
>>
>
> Well it's not really tux-on-ice's fault, freeze wouldn't work _at all_ via the
> ioctl or any other method, we just happened to notice it was broken because
> people using tux-on-ice were getting corrupt filesystems after suspend :).  Btw,
> it may be good to have freezer_sync set to 1 by default, otherwise if an fs
> doesnt support freezing it will likely end up corrupted too.  Thanks,

Corrupted because the sys_sync was disabled? (We were recently 
discussing adding a tuneable to swsusp for disabling sys_sync there too).

I've just committed a patch making freezer_sync default to 1.

Regards,

Nigel
