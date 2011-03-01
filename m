Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755490Ab1CAC0J (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Feb 2011 21:26:09 -0500
Received: from mail-vw0-f46.google.com ([209.85.212.46]:61899 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753626Ab1CAC0G convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Feb 2011 21:26:06 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=N/RYWF3UpKsQaj2t2k8PVJpRUbr49imZsuT9AjIc3dFJmvaPZSg44uLoae0NNIVNLL
         rzXjItgNh9h5NmitQD7u2QXGkytFoEGdLNO0++BdQ5r9wRrNkCggTcH23jWT+78Tcwun
         idt2mMaXP1BJgqnrOzKJGBy9xcgQDmxk7oA2I=
MIME-Version: 1.0
In-Reply-To: <4D6C57A2.3040500@linux.vnet.ibm.com>
References: <AANLkTimyu6A=LgF8pit6So6JkPrScFLB42U3NwBJq7mv@mail.gmail.com>
	<20110228131118.GA18193@dhcp231-156.rdu.redhat.com>
	<OFF2910C77.5B46C8B2-ON87257846.000354EE-07257846.000414E9@us.ibm.com>
	<AANLkTikkDS38RhwP9LC47_Q-ZnUB_6q=EKRyQ8tswKW=@mail.gmail.com>
	<4D6C57A2.3040500@linux.vnet.ibm.com>
Date: Tue, 1 Mar 2011 10:26:03 +0800
Message-ID: <AANLkTimEFjQ2x86HgTJ3AwZ_oBXTZc_PdGzAHhacUEM7@mail.gmail.com>
Subject: Re: ext2/3/4: punch support?
From: Dave Young <hidave.darkstar@gmail.com>
To: Allison Henderson <achender@linux.vnet.ibm.com>
Cc: Allison C Henderson <achender@us.ibm.com>, Josef Bacik <josef@redhat.com>,
        linux-ext4@vger.kernel.org, linux-ext4-owner@vger.kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Theodore Tso <tytso@mit.edu>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 1, 2011 at 10:19 AM, Allison Henderson
<achender@linux.vnet.ibm.com> wrote:
> Alrighty then, I can send it out a little early since people are interested.  It should show up here soon.  Any feedback is appreciated! :)

Hi, top post is bad here, please don't do that.

>
> Allison Henderson
>
> On 2/28/2011 6:32 PM, Dave Young wrote:
>> On Tue, Mar 1, 2011 at 8:44 AM, Allison C Henderson<achender@us.ibm.com>  wrote:
>>>
>>> Hi All,
>>>
>>> I've actually already started on a patch set for punch hole support in ext4.
>>>   I've sent them out on the ltc-fsdev mailing list for review.  I had planned
>>> to spend another week or two running it through some more debug cases before
>>> sending it to the ext4 mailing list though.
>>
>> Where can find your patch? should be sent to linux-ext4?
>>


-- 
Regards
dave
