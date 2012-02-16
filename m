Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755087Ab2BPXhT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Feb 2012 18:37:19 -0500
Received: from mail-tul01m020-f174.google.com ([209.85.214.174]:49271 "EHLO
	mail-tul01m020-f174.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751896Ab2BPXhR convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Feb 2012 18:37:17 -0500
MIME-Version: 1.0
In-Reply-To: <4F3D90E1.6010001@redhat.com>
References: <AANLkTinRC1hXvaXDVV5pOA4YyCdXwAjziZsDzm=LuHqK@mail.gmail.com>
	<AANLkTinewk=mJZifVxEJkCtKfNauOjHnLAqwbGn139C=@mail.gmail.com>
	<AANLkTikui_HQ5JMcMJUqMr9WLyTRNzF-z4G7wAUNPOFy@mail.gmail.com>
	<201103242330.14416.rjw@sisk.pl>
	<CAFLxGvzzHDRma_Y_XEpOD+fY+vonbkoR1mvQp4Vb4c3M6fTsPA@mail.gmail.com>
	<20120216163030.GA32651@redhat.com>
	<4F3D90E1.6010001@redhat.com>
Date: Fri, 17 Feb 2012 00:37:17 +0100
Message-ID: <CAFLxGvz4MUQrLUs=CWVbWspKQoBC7qiLTUyWQMKzgeX8r3L8VA@mail.gmail.com>
Subject: Re: Corrupted files after suspend to disk
From: richard -rw- weinberger <richard.weinberger@gmail.com>
To: Eric Sandeen <sandeen@redhat.com>
Cc: Dave Jones <davej@redhat.com>, "Rafael J. Wysocki" <rjw@sisk.pl>,
        LKML <linux-kernel@vger.kernel.org>,
        linux-pm@lists.linux-foundation.org, esandeen@redhat.com
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 17, 2012 at 12:27 AM, Eric Sandeen <sandeen@redhat.com> wrote:
> On 2/16/12 8:30 AM, Dave Jones wrote:
>> On Thu, Feb 16, 2012 at 11:52:27AM +0100, richard -rw- weinberger wrote:
>>
>>  > >> >> Of course, please test the above separately. :-)
>>  > >> >
>>  > >> > Ok, I'll test this when I'm at home.
>>  > >> >
>>  > >> > BTW: dropping the caches helps, when some files seem corrupted.
>>  > >> > Today /usr/bin/okular was broken.
>>  > >> > After setting vm.drop_caches=1 it worked again.
>>  > >>
>>  > >> On Linux 2.6.38 I'm unable to reproduce the issue.
>>  > >> Only 2.6.37 seems to be affected.
>>  > >> So, I'm moving over to 2.6.38. :)
>>  > >
>>  > Bad news:
>>  > I saw the issue on 3.x too but thought it's because my IdeaPad s10 is crap.
>>  > Now with my shiny new Lenovo x121e I have the same issue! :-(
>>  >
>>  > OpenSUSE 12.1, kernel 3.2.7.
>>  > After a few suspend2disk iterations random files are corrupted.
>>  > But only cached files. A reboot solves the problem.
>
> Just to be clear - you see _data_ corruption in files, but only
> until a reboot, and after that they are ok?  Ok, reading above
> about using drop_caches that sounds like the case.

Yes.
A reboot always solved the data corruption.
drop_caches solved it in 99% of all cases.

On-disk data was never corrupted.

-- 
Thanks,
//richard
