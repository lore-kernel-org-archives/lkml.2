Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756045Ab1DKItp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Apr 2011 04:49:45 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:38161 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755438Ab1DKItn convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Apr 2011 04:49:43 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=nFaHo9MP7DNao2uOxLHYPWmvMF3QXJil9Y+R6gE8BTJHn8JF+LIdFjCz3zy+Cw2JlD
         9nb7q8mUf6djLspMx4s2YFROL+MMnLB7mh3T5ORHpyOqVrG/7Wp5wRDeHxkjvl6vhAdT
         WAtYY7zt5caE8Jd61WXF7ECrVyjiI6kiJzJaU=
MIME-Version: 1.0
In-Reply-To: <BANLkTimdxt=LGh0WZZ=uXMuCupja-ckDOg@mail.gmail.com>
References: <201011181650.00152.roucaries.bastien@gmail.com>
	<AANLkTinp4=c9qmVyfocUk_ydJ3PV50b9UckNhJJNFsFm@mail.gmail.com>
	<AANLkTimYiRYZVXtxLBNeGcG=KVJTTiaGn+XGYP2Y=XMo@mail.gmail.com>
	<201103311704.40372.roucaries.bastien@gmail.com>
	<BANLkTikmtyyMes84rED5wpMxuN8kL91jEw@mail.gmail.com>
	<4D9B3C10.9060704@suse.com>
	<BANLkTi=XDzOcZsP+aKS_WQSRxT+N8XHBRQ@mail.gmail.com>
	<BANLkTi=yTfMiLvVtZTqQvxVhy7aFPdwSXQ@mail.gmail.com>
	<BANLkTi=KUMNWJZZBQSHK+WViy6BYv8+4dQ@mail.gmail.com>
	<BANLkTi=LHx-cwQ8dAY7ogLN0B5xtJApVWg@mail.gmail.com>
	<BANLkTimdxt=LGh0WZZ=uXMuCupja-ckDOg@mail.gmail.com>
Date: Mon, 11 Apr 2011 10:49:42 +0200
Message-ID: <BANLkTinuaW86bBkYyshb3jL-5jdogmgiFQ@mail.gmail.com>
Subject: Re: Reiserfs deadlock in 2.6.36
From: Bastien ROUCARIES <roucaries.bastien@gmail.com>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Jeff Mahoney <jeffm@suse.com>, Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org, Thomas Koch <thomas@koch.ro>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 11, 2011 at 10:49 AM, Bastien ROUCARIES
<roucaries.bastien@gmail.com> wrote:
> On Mon, Apr 11, 2011 at 10:40 AM, Bastien ROUCARIES
> <roucaries.bastien@gmail.com> wrote:
>> Any news ? Can I test some patch ?
>
> Seems also Thomas Koch  was hit by this bug. May be it could comment ?
>

Source http://bugs.debian.org/cgi-bin/bugreport.cgi?bug=616334
> Bastien
>
>> Bastien
>>
>> On Wed, Apr 6, 2011 at 12:14 PM, Bastien ROUCARIES
>> <roucaries.bastien@gmail.com> wrote:
>>> On Wed, Apr 6, 2011 at 12:58 AM, Frederic Weisbecker <fweisbec@gmail.com> wrote:
>>>> 2011/4/5 Bastien ROUCARIES <roucaries.bastien@gmail.com>:
>>>>> On Tue, Apr 5, 2011 at 5:58 PM, Jeff Mahoney <jeffm@suse.com> wrote:
>>>>>> -----BEGIN PGP SIGNED MESSAGE-----
>>>>>> Hash: SHA1
>>>>>>
>>>>>> On 04/05/2011 09:30 AM, Bastien ROUCARIES wrote:
>>>>>>> Ping ? You said on bugzilla it is related to acl but see nothing
>>>>>>
>>>>>> Yeah, I think it's related to the nesting not being quite right, but I
>>>>>> need to look into it more. I've been unable to reproduce the problem
>>>>>> locally.
>>>>>
>>>>> You could reproduce quite easilly using with a lot of git pull in
>>>>> parallel (in a lot of different repo)... In less than one hours if you
>>>>> have luck
>>>>>
>>>>> Bastien
>>>>
>>>> Ah. I'm going to try that.
>>>> Can you perhaps send us your .config, in case it happens only on some
>>>> specific set. And also your options passed to mount reiserfs in /etc/fstab ?
>>>
>>> Config file is the same than previously
>>> mount option are rw,nosuid,nodev,relatime,user_xattr,acl
>>>
>>> Bastien
>>>
>>>> Thanks.
>>>>
>>>
>>
>
