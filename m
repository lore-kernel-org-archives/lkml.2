Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756063Ab0ENGeu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 May 2010 02:34:50 -0400
Received: from mail-ww0-f46.google.com ([74.125.82.46]:57637 "EHLO
	mail-ww0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752238Ab0ENGes (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 May 2010 02:34:48 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=ubWBUd5yt+Jg5UoIgMf08q3SPESyjppak+9c5wijh/kINujBr4YMH6YRpu+Bbx+fTI
         ukG7o5DjfL6GuSXqYTckXxe1uxJbX2mNtLdyhiY17W+JuLX/nDe0P9Hm+0vcIm2xNc1W
         MKi1fy28IDxemPzfZA+/B78j3abT/qAWR55pU=
MIME-Version: 1.0
In-Reply-To: <20100513235542.GA30093@tango.0pointer.de>
References: <4BEAB6FC.8090105@intcomgrp.com> <1273674048.1626.117.camel@laptop>
	 <20100512190757.GA421@tango.0pointer.de>
	 <1273755719.5605.3537.camel@twins>
	 <20100513140354.GA12639@tango.0pointer.de>
	 <s2s6599ad831005131306pa7db4c4dyd7712de7fda73cfd@mail.gmail.com>
	 <20100513203654.GA14528@tango.0pointer.de>
	 <20100513204159.GA15291@tango.0pointer.de>
	 <20100513210738.GV3296@balbir.in.ibm.com>
	 <20100513235542.GA30093@tango.0pointer.de>
Date: Fri, 14 May 2010 08:34:46 +0200
Message-ID: <AANLkTil_5HNK_ADI2ueiErLp81Rwxm4okRKzsBZaoNXN@mail.gmail.com>
Subject: Re: [PATCH/RFC] Have sane default values for cpusets
From: Dhaval Giani <dhaval.giani@gmail.com>
To: Lennart Poettering <mzxreary@0pointer.de>
Cc: Balbir Singh <balbir@linux.vnet.ibm.com>, Paul Menage <menage@google.com>,
       Peter Zijlstra <peterz@infradead.org>,
       James Kosin <jkosin@intcomgrp.com>, linux-kernel@vger.kernel.org,
       jsafrane@redhat.com, tglx@linutronix.de
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 14, 2010 at 1:55 AM, Lennart Poettering
<mzxreary@0pointer.de> wrote:
> On Fri, 14.05.10 02:37, Balbir Singh (balbir@linux.vnet.ibm.com) wrote:
>
>> > > Oh, that is possible? How would I do that?
>> > >
>> > > This certainly doesn't work:
>> > >
>> > > # mount waldo -t cgroup /tmp/xxxx -o defaults
>> >
>> > An neither does this:
>> >
>> > # mount waldo -t cgroup /tmp/xxxx -o name=systemd
>> >
>> > (the mount() syscall fails with EINVAL here, the other one fails with EBUSY)
>> >
>>
>> Can you try the command below
>>
>> mount -t cgroup cgroup -o none,name=hello /cgroup/
>>
>> Works for me.
>
> That line certainly works, but unfortunately your own libcgroup
> completely ignores mount points like this. Meh.
>

That be my mistake. I missed this update to cgroups. A patch will be
coming out pretty soon!

Dhaval
