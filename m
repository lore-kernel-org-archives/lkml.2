Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933656Ab1JZQjU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Oct 2011 12:39:20 -0400
Received: from oproxy8-pub.bluehost.com ([69.89.22.20]:39823 "HELO
	oproxy8-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S932982Ab1JZQjS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Oct 2011 12:39:18 -0400
Message-ID: <4EA837AD.6070700@xenotime.net>
Date: Wed, 26 Oct 2011 09:39:09 -0700
From: Randy Dunlap <rdunlap@xenotime.net>
Organization: YPO4
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:7.0.1) Gecko/20111001 Thunderbird/7.0.1
MIME-Version: 1.0
To: Mike Galbraith <efault@gmx.de>
CC: Valdis.Kletnieks@vt.edu, Greg KH <gregkh@suse.de>,
        linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        torvalds@linux-foundation.org, stable@vger.kernel.org, lwn@lwn.net
Subject: Re: Linux 3.0.8
References: <20111025051928.GA7997@kroah.com>  <4EA64BDC.8050709@xenotime.net> <20111025070240.GB9415@suse.de>  <14295.1319532063@turing-police.cc.vt.edu> <1319616850.4829.28.camel@marge.simson.net>
In-Reply-To: <1319616850.4829.28.camel@marge.simson.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Identified-User: {1807:box742.bluehost.com:xenotime:xenotime.net} {sentby:smtp auth 50.53.38.135 authed with rdunlap@xenotime.net}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/26/11 01:14, Mike Galbraith wrote:
> On Tue, 2011-10-25 at 04:41 -0400, Valdis.Kletnieks@vt.edu wrote:
>> On Tue, 25 Oct 2011 09:02:40 +0200, Greg KH said:
>>> On Mon, Oct 24, 2011 at 10:40:44PM -0700, Randy Dunlap wrote:
>>>> On 10/24/11 22:19, Greg KH wrote:
>>>>> All users of the 3.0 kernel series must upgrade.
>>>> I noticed that "must" word in 3.0.7 also.  Please explain.
>>> Nothing new, I've been saying that for years.
>>
>> I think Randy means that out of the 29 commits for .7->.8, there's only one
>> (Hugh Dicken's mremap fix) and *maybe* Peter Zijlstra's cputimer fix, which
>> even *possibly* rise to the "all users" level, as everything else is against
>> XFS or CIFS or ARM or something else that's not an across-the-board issue.
>>
>> And the changelog for the mremap commit says that "but this lucky report
>> hints", which sort of implies it's a very hard-to-hit bug that nobody even knew
>> was there.
>>
>> So it's not obvious from just the shortlog that it's a "MUST upgrade"  category.
> 
> Seems like perfectly fine boilerplate to me.  If I want the warmest
> fuzzy I can get, I must upgrade.  Peter's patch fixed a box killer that
> I don't care to hit (dead bugs being kinda boring), so I must upgrade.

Sure, if it's just boilerplate, that's fine.
My mistake was thinking that it was something new & different.


-- 
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
