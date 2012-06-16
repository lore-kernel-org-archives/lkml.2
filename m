Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756106Ab2FPRom (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Jun 2012 13:44:42 -0400
Received: from oproxy5-pub.bluehost.com ([67.222.38.55]:44498 "HELO
	oproxy5-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1755551Ab2FPRol (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Jun 2012 13:44:41 -0400
Message-ID: <4FDCC5F5.1060601@xenotime.net>
Date: Sat, 16 Jun 2012 10:44:21 -0700
From: Randy Dunlap <rdunlap@xenotime.net>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.15) Gecko/20110323 Thunderbird/3.1.9
MIME-Version: 1.0
To: Fengguang Wu <wfg@linux.intel.com>
CC: Josh Triplett <josh@freedesktop.org>,
        Dan Carpenter <dan.carpenter@oracle.com>, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org, Julia Lawall <julia.lawall@lip6.fr>,
        Peter Senna Tschudin <peter.senna@gmail.com>,
        Cong Wang <xiyou.wangcong@gmail.com>
Subject: Re: automated warning notifications
References: <20120614172523.GB4400@mwanda> <20120615014835.GA5695@localhost> <20120615071222.GZ13539@mwanda> <20120615075810.GA13206@localhost> <20120615083100.GA29692@leaf> <20120615085405.GB13933@localhost> <4FDB675A.7040808@xenotime.net> <20120616091744.GB10332@localhost>
In-Reply-To: <20120616091744.GB10332@localhost>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Identified-User: {1807:box742.bluehost.com:xenotime:xenotime.net} {sentby:smtp auth 50.53.38.135 authed with rdunlap@xenotime.net}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/16/2012 02:17 AM, Fengguang Wu wrote:

> On Fri, Jun 15, 2012 at 09:48:26AM -0700, Randy Dunlap wrote:
>> On 06/15/2012 01:54 AM, Fengguang Wu wrote:
>>
>>> On Fri, Jun 15, 2012 at 01:31:00AM -0700, Josh Triplett wrote:
>>>> On Fri, Jun 15, 2012 at 03:58:10PM +0800, Fengguang Wu wrote:
>>>>> On Fri, Jun 15, 2012 at 10:12:22AM +0300, Dan Carpenter wrote:
>>>>>> On Fri, Jun 15, 2012 at 09:48:35AM +0800, Fengguang Wu wrote:
>>>>>>> In an average working day, 1-2 build errors will be caught and email
>>>>>>> notified. I guess there will be more sparse warnings if it's turned
>>>>>>> on.
>>>>>>>
>>>>>>> Perhaps the sparse warnings can be enabled, but only sent to the patch
>>>>>>> author. If you and anyone else are interested, they could be sent to
>>>>>>> some mailing list, too. One thing I'm sure is, we probably never want
>>>>>>> to disturb the busy maintainers with these warnings.
>>>>>>
>>>>>> Eventually I think we will want to set up a mailing list for this or
>>>>>> we will start sending duplicate messages.
>>>>>
>>>>> Fair enough. How can we setup the mailing list? Once the list up, it
>>>>> would be trivial for me to send sparse warnings out there.
>>>>
>>>> Rather than a mailing list, how about something like test.kernel.org for
>>>> sparse warnings?
>>>
>>> It's much more trivial to send new build/sparse errors/warnings to a
>>> list than to setup a website :-) As the errors come and go every day,
>>> and they are mostly unstructured, it seems the mailing list would be a
>>> more natural fit. People can search for known errors there and/or CC
>>> fixes there.
>>>
>>> Anyway, we just sent an request for creating
>>>
>>>         automated-warnings@vger.kernel.org
>>
>>
>> and you will let us know when it has been created??
> 
> Well, the request has been rejected anyway..
> 
>> Although I had just as soon use an existing list, like
>> kernel-janitors or kernel-testers.
> 
> From http://kernelnewbies.org/KernelJanitors :
> 
> Some suggestions to kernel newbies:
> 
>         avoid fixing compiler warnings  because the goal is to fix the
>         CAUSE of the warnings (which is usually not obvious), not just
>         to make the warnings go away 
> 
> Does that suggest the commit author be the best people to fix
> warnings? The typical situation may be, the author is not aware of the
> warnings at all: they are buried in the tedious output of make...


It's a shame when a patch creates lots of warnings and they are
ignored.  I would suggest that the patch should not be merged.  :)

We should at least bring the warnings to the attention of the
patch author.  Sure, in some cases we (I) might make a patch that
the author wouldn't want and would have better solutions for.
That's OK.  It happens often.  It's part of how Linux development works.



-- 
~Randy
