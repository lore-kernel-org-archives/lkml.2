Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752392Ab2FOQsp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Jun 2012 12:48:45 -0400
Received: from oproxy5-pub.bluehost.com ([67.222.38.55]:40697 "HELO
	oproxy5-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751190Ab2FOQso (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Jun 2012 12:48:44 -0400
Message-ID: <4FDB675A.7040808@xenotime.net>
Date: Fri, 15 Jun 2012 09:48:26 -0700
From: Randy Dunlap <rdunlap@xenotime.net>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.15) Gecko/20110323 Thunderbird/3.1.9
MIME-Version: 1.0
To: Fengguang Wu <wfg@linux.intel.com>
CC: Josh Triplett <josh@freedesktop.org>,
        Dan Carpenter <dan.carpenter@oracle.com>, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org, Pekka Enberg <penberg@kernel.org>,
        Al Viro <viro@zeniv.linux.org.uk>, Christopher Li <sparse@chrisli.org>,
        Linus Torvalds <torvalds@ppc970.osdl.org>
Subject: Re: automated warning notifications
References: <20120614172523.GB4400@mwanda> <20120615014835.GA5695@localhost> <20120615071222.GZ13539@mwanda> <20120615075810.GA13206@localhost> <20120615083100.GA29692@leaf> <20120615085405.GB13933@localhost>
In-Reply-To: <20120615085405.GB13933@localhost>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Identified-User: {1807:box742.bluehost.com:xenotime:xenotime.net} {sentby:smtp auth 50.53.38.135 authed with rdunlap@xenotime.net}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/15/2012 01:54 AM, Fengguang Wu wrote:

> On Fri, Jun 15, 2012 at 01:31:00AM -0700, Josh Triplett wrote:
>> On Fri, Jun 15, 2012 at 03:58:10PM +0800, Fengguang Wu wrote:
>>> On Fri, Jun 15, 2012 at 10:12:22AM +0300, Dan Carpenter wrote:
>>>> On Fri, Jun 15, 2012 at 09:48:35AM +0800, Fengguang Wu wrote:
>>>>> In an average working day, 1-2 build errors will be caught and email
>>>>> notified. I guess there will be more sparse warnings if it's turned
>>>>> on.
>>>>>
>>>>> Perhaps the sparse warnings can be enabled, but only sent to the patch
>>>>> author. If you and anyone else are interested, they could be sent to
>>>>> some mailing list, too. One thing I'm sure is, we probably never want
>>>>> to disturb the busy maintainers with these warnings.
>>>>
>>>> Eventually I think we will want to set up a mailing list for this or
>>>> we will start sending duplicate messages.
>>>
>>> Fair enough. How can we setup the mailing list? Once the list up, it
>>> would be trivial for me to send sparse warnings out there.
>>
>> Rather than a mailing list, how about something like test.kernel.org for
>> sparse warnings?
> 
> It's much more trivial to send new build/sparse errors/warnings to a
> list than to setup a website :-) As the errors come and go every day,
> and they are mostly unstructured, it seems the mailing list would be a
> more natural fit. People can search for known errors there and/or CC
> fixes there.
> 
> Anyway, we just sent an request for creating
> 
>         automated-warnings@vger.kernel.org


and you will let us know when it has been created??

Although I had just as soon use an existing list, like
kernel-janitors or kernel-testers.

thanks,
-- 
~Randy
