Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753380Ab0CXAY1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Mar 2010 20:24:27 -0400
Received: from crca.org.au ([74.207.252.120]:40877 "EHLO crca.org.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751734Ab0CXAY0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Mar 2010 20:24:26 -0400
X-Bogosity: Ham, spamicity=0.000000
Message-ID: <4BA95BEB.7040805@crca.org.au>
Date: Wed, 24 Mar 2010 11:25:15 +1100
From: Nigel Cunningham <ncunningham@crca.org.au>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9pre) Gecko/20100301 Shredder/3.0.4pre
MIME-Version: 1.0
To: Al Viro <viro@ZenIV.linux.org.uk>
CC: Josef Bacik <josef@redhat.com>, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org, chris.mason@oracle.com, hch@lst.de
Subject: Re: [PATCH] Introduce freeze_super and thaw_super for the fsfreeze
 ioctl
References: <20100323142200.GA2381@localhost.localdomain> <20100323142843.GG30031@ZenIV.linux.org.uk> <20100323143456.GC2381@localhost.localdomain> <20100323144828.GH30031@ZenIV.linux.org.uk> <20100323150301.GD2381@localhost.localdomain> <20100323150923.GI30031@ZenIV.linux.org.uk> <4BA94157.6090907@crca.org.au> <20100323231802.GL30031@ZenIV.linux.org.uk> <4BA95454.1080400@crca.org.au> <4BA95501.4000806@crca.org.au> <20100324002117.GN30031@ZenIV.linux.org.uk>
In-Reply-To: <20100324002117.GN30031@ZenIV.linux.org.uk>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi.

On 24/03/10 11:21, Al Viro wrote:
> On Wed, Mar 24, 2010 at 10:55:45AM +1100, Nigel Cunningham wrote:
>> Hi again.
>>
>> On 24/03/10 10:52, Nigel Cunningham wrote:
>>>> I've stayed away from TuxOnIce flamefests and I've no idea how
>>>> representative
>>>> that snippet is, but if it *does* match the general code quality in
>>>> there...
>>>> Ouch.
>>>
>>> Locking isn't necessary because of the freezing.
>>
>> Err, freezer, I mean.
>
> Even leaving aside the accuracy of that (and I seriously doubt it), this
> is completely wrong since *code* *gets* *copied*.

Ok. That's a fair enough point. I'll add locking.

Regards,

Nigel
