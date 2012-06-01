Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964879Ab2FAPQl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Jun 2012 11:16:41 -0400
Received: from mail-vb0-f46.google.com ([209.85.212.46]:53639 "EHLO
	mail-vb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964820Ab2FAPQk convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Jun 2012 11:16:40 -0400
MIME-Version: 1.0
In-Reply-To: <1338492342.5861.23.camel@joe2Laptop>
References: <CAFU-uVs_Gwacxj74cyekY2gv+zAq+Spba7nfPLdTc_dR3y8CYw@mail.gmail.com>
 <20120516143830.GA483@kroah.com> <alpine.LNX.2.00.1205161640520.8796@pobox.suse.cz>
 <CAFU-uVt94sgzq7DgsgKL2OJ0e7DazvNpFunx7BNEz88LHJOg+g@mail.gmail.com>
 <20120516150813.GA3293@kroah.com> <CAFU-uVvzyN0asmReOVJcAEiAtbQ=styfGxRRbnrJKgNFDS5X_g@mail.gmail.com>
 <CAFU-uVsStG0KoiQm95-uC8ZPXWAq=8Q8vXircxOuUCHhk+r9uw@mail.gmail.com> <1338492342.5861.23.camel@joe2Laptop>
From: Philipp Riemer <ruderphilipp@gmail.com>
Date: Fri, 1 Jun 2012 17:16:15 +0200
Message-ID: <CAFU-uVs7tc8yZWp7sGbtosHevcdrzPuo_XRWHBU6qBAokiRUGA@mail.gmail.com>
Subject: Re: [GIT PULL] new mailmap file for the linux kernel git repository
To: Joe Perches <joe@perches.com>
Cc: Greg KH <gregkh@linuxfoundation.org>, Jiri Kosina <jkosina@suse.cz>,
        Paul Mundt <lethal@linux-sh.org>,
        =?ISO-8859-1?Q?Michael_B=FCsch?= <m@bues.ch>,
        Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>,
        =?ISO-8859-1?Q?Uwe_Kleine=2DK=F6nig?= 
	<u.kleine-koenig@pengutronix.de>,
        LKML <linux-kernel@vger.kernel.org>, Wang Chen <ellre923@gmail.com>,
        Jonathan Corbet <corbet@lwn.net>,
        Linus Torvalds <torvalds@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thank you for your feedback.

2012/5/31 Joe Perches <joe@perches.com>:
> On Thu, 2012-05-31 at 18:08 +0200, Philipp Riemer wrote:
>> updated mailmap file for LK repository
>>
>> The current version of the .mailmap file does only capture a fraction of errors
>> and ambiguity when looking at developers emails and names. Hence, this revised
>> version tries to address many more names and, as a result, to clarify maintainer
>> information. Issues addressed:
>>  - Typos in names
>>  - Typos in mails
>>  - Mapping of ambiguous mail adresses (e.g. {aa@bb.cc, aa@home.(none),
>>    aa@laptop.bb.cc,...} becomes {aa@bb.cc}) but keeping LKML specific ones
>>  - Mapping of names to entries with only email information
>>  - Correct usage of special character (e.g. German umlauts)
>>  - Harmonization of position and style of last name (no more all-caps names
>>    like "First LAST" or those of "Last, First")
>>  - No initials in names if not necessary
>
> Removing initials is probably not a good idea.
>
>>  - Conversion of email addresses to lower case
>>
>> Signed-off-by: Philipp Riemer <ruderphilipp@gmail.com>
>> ---
>> Finally I am back from my trip through Germany and after attending
>> LinuxTag in Berlin last week, reading Documentation/SubmittingPatches,
>> and checking other patch submissions, I give this topic finally a new
>> try...  Hopefully my submission confirms to the LK standards this
>> time. I can certify that this contribution was conscientiously created
>> in whole by me and therefore added the sign-off message.
>>
>> Please pull from
>>
>>               git://github.com/ruderphilipp/linux.git mailmap-changes
>>
>> to get the changes in the attached patch file (since even the
>> web-interface of GMail wraps lines) -- or simply inspect/apply that
>> file directly.
>>
>> $ git diffstat upstream/master..origin/mailmap-changes .mailmap
>>  .mailmap | 2482 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++-
>>  1 file changed, 2444 insertions(+), 38 deletions(-)
>>
>
> I'm still not sure this is really necessary.
So, what is the sense of this file in your eyes?

> It's pretty big and would need continual ongoing
> maintenance for what seems to me relatively little
> value.
>
> Maybe you can diff the git shortlog before and after
> this patch and determine if this is really useful.
Thanks for the tip! I did not consider that... (*embarrassing*)

I diffed the output like you suggested (but changed the command to
"git shortlog -s -e" to have a list sorted by names and not by commits
since these change due to the fact that the authors are now better
mapped).
Than I started to sort the entries. You can find it at
<https://github.com/ruderphilipp/linux/blob/mailmap-changes/shortlog.diff>.
Since there a lot of them, I am not finished yet and it is still work
in progress. But I already found some minor errors that I will fix
before re-submitting again.

>
> Also, some of these entries look odd at first glance:
>
> +Adam Brooks <adam.j.brooks@gmail.com>                   <From: jiang.adam@gmail.com>
>
> Is that the same person?
To be honest, I added this line to see if anyone even looks at the
file... I now changed it to the correct name since of course these are
not the same.

> -Al Viro <viro@ftp.linux.org.uk>
> -Al Viro <viro@zenIV.linux.org.uk>
> []
> +Alexander Viro <viro@ftp.linux.org.uk>
>
> I think I've never seen that name before.
>
> I stopped looking at the patch after that.
>
> I ran a git shortlog -n -s before and after
> your patch and I'm a bit confused by the
> result.
>
> Some people seem to be missing altogether.
>        (Avi Kivity, etc...)
> Some people have _fewer_ commits.
>        (Andrew Morton, etc...)
>
> Any idea why?
Currently investigating that...

> Here's just the start, it's a long diff
>
> --- shortlog.ns.old     2012-05-31 12:08:12.776091892 -0700
> +++ shortlog.ns.new     2012-05-31 12:07:55.596091644 -0700
> @@ -1,262 +1,260 @@
>  12313 Linus Torvalds
> -  4232 David S. Miller
> +  4383 David Miller
>   3627 Takashi Iwai
> -  3566 Ingo Molnar
> -  3208 Al Viro
> +  3568 Ingo Molnar
> +  3211 Alexander Viro
> +  2874 Russell King
>   2860 Mark Brown
> -  2770 Russell King
> ...
>
