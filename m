Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753856Ab2JBNN2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Oct 2012 09:13:28 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:52841 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753503Ab2JBNN0 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Oct 2012 09:13:26 -0400
MIME-Version: 1.0
In-Reply-To: <CALF0-+WcUzsQ3b3gyCoauAYmmV3xDT7H1veKkabhvC8hofCWAA@mail.gmail.com>
References: <1349179024-5319-1-git-send-email-peter.senna@gmail.com>
	<20121002121443.GT4587@mwanda>
	<CA+MoWDqxXPiuFwmznynn8SPK20eJUgCKonq+C=s8fKvcnkb4Aw@mail.gmail.com>
	<CALF0-+W25fAD0=kLD085G+H1b-WFaARudo-hkJO_LoBTNZC-Nw@mail.gmail.com>
	<CA+MoWDoy+cqkzDHmR2=-3UhMn-i+fU0RVKwtkcsgRxOBk98oYA@mail.gmail.com>
	<CALF0-+WcUzsQ3b3gyCoauAYmmV3xDT7H1veKkabhvC8hofCWAA@mail.gmail.com>
Date: Tue, 2 Oct 2012 15:13:25 +0200
Message-ID: <CA+MoWDrMbkZYnRpEp5bAivZohVnZ4xPG0v3Wr_0ks_myzhCBDg@mail.gmail.com>
Subject: Re: [PATCH RFC] MAINTAINERS: Add section for subsystem shortname
From: Peter Senna Tschudin <peter.senna@gmail.com>
To: Ezequiel Garcia <elezegarcia@gmail.com>
Cc: Dan Carpenter <dan.carpenter@oracle.com>, joe@perches.com,
        gregkh@linuxfoundation.org, davem@davemloft.net, arnd@arndb.de,
        Julia.Lawall@lip6.fr, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 2, 2012 at 3:08 PM, Ezequiel Garcia <elezegarcia@gmail.com> wrote:
> On Tue, Oct 2, 2012 at 9:53 AM, Peter Senna Tschudin
> <peter.senna@gmail.com> wrote:
>> On Tue, Oct 2, 2012 at 2:40 PM, Ezequiel Garcia <elezegarcia@gmail.com> wrote:
>>> On Tue, Oct 2, 2012 at 9:33 AM, Peter Senna Tschudin
>>> <peter.senna@gmail.com> wrote:
>>>> On Tue, Oct 2, 2012 at 2:14 PM, Dan Carpenter <dan.carpenter@oracle.com> wrote:
>>>>> On Tue, Oct 02, 2012 at 01:57:04PM +0200, Peter Senna Tschudin wrote:
>>>>>> The shortname for a subsystem, that is primarly used when sending patches over E-mail, is not stored anywhere in the source code. Actually one need to dig git log or mailing list archives. There is no standard, and the Maintainer choose how to short name his/her subsystem. MAINTAINERS file is the right place for storing this information.
>>>>>>
>>>>>> U is the second letter of Subsystem.
>>>>>>
>>>>>> This will also enable automatic tools like scripts/get_maintainer.pl to provide the correct short name for each filename in the Kernel source tree.
>>>>>>
>>>>>
>>>>> This is pretty useless without a script to parse it.  Also none of
>>>> With or without a script, there is no default way of finding the short
>>>> name. Changing scripts/get_maintainer.pl to do it does not seems very
>>>> complex.
>>>>
>>>
>>> Perhaps you should do get_maintainer.pl changes yourself and then
>>> use it to test on some of your patches to see what subject it produces.
>> What are your doubts about this method of getting the short name?
>>
>
> No doubts so far since I haven't seen it in action.
> Some script results and more examples could help.
>
>>>
>>> Then it's easier to see if the proposal makes sense.
>>> A new rule / standard is something hard to push and we want to have as much
>>> facts as possible to make better decisions.
>> The fact is that currently there is no standard way of getting the
>> short name for a subsystem. My proposal fixes it allowing to look on
>> the MAINTAINERS file to see what short name to use.
>>
>
> There is no standard way of getting short name, and there isn't standard
> way of naming a patch either.
>
> Just looking through media list I can spot lots of different subject schemes:
>   [media] foo: fix some bug
>   media: foo: fix some bug
>   foo: fix some bug
>   Some random text and fix some bug

According to:

http://yarchive.net/comp/linux/commit_messages.html

the subsystem short name is also important for whom is not working
directly on that subsystem but may receive the E-mail with the
patch...


>
> Regards,
> Ezequiel.



-- 
Peter
