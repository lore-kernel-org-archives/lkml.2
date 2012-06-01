Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965492Ab2FAQWm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Jun 2012 12:22:42 -0400
Received: from mail-vc0-f174.google.com ([209.85.220.174]:35296 "EHLO
	mail-vc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965470Ab2FAQWd convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Jun 2012 12:22:33 -0400
MIME-Version: 1.0
In-Reply-To: <20120601075848.GB9920@kroah.com>
References: <CAFU-uVs_Gwacxj74cyekY2gv+zAq+Spba7nfPLdTc_dR3y8CYw@mail.gmail.com>
 <20120516143830.GA483@kroah.com> <alpine.LNX.2.00.1205161640520.8796@pobox.suse.cz>
 <CAFU-uVt94sgzq7DgsgKL2OJ0e7DazvNpFunx7BNEz88LHJOg+g@mail.gmail.com>
 <20120516150813.GA3293@kroah.com> <CAFU-uVvzyN0asmReOVJcAEiAtbQ=styfGxRRbnrJKgNFDS5X_g@mail.gmail.com>
 <CAFU-uVsStG0KoiQm95-uC8ZPXWAq=8Q8vXircxOuUCHhk+r9uw@mail.gmail.com> <20120601075848.GB9920@kroah.com>
From: Philipp Riemer <ruderphilipp@gmail.com>
Date: Fri, 1 Jun 2012 18:22:11 +0200
Message-ID: <CAFU-uVs2y8jdVUZzFu7WGTEivosUPZXREXxsRrwFdCY3X7eQtg@mail.gmail.com>
Subject: Re: [GIT PULL] new mailmap file for the linux kernel git repository
To: Greg KH <gregkh@linuxfoundation.org>
Cc: Jiri Kosina <jkosina@suse.cz>, Paul Mundt <lethal@linux-sh.org>,
        =?ISO-8859-1?Q?Michael_B=FCsc?= =?ISO-8859-1?Q?h?= <m@bues.ch>,
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

2012/6/1 Greg KH <gregkh@linuxfoundation.org>:
> On Thu, May 31, 2012 at 06:08:48PM +0200, Philipp Riemer wrote:
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
>
> Where did you get some of these email addresses from?  My "kroah.org"
> entries never showed up in the kernel commit logs, nor are they valid email
> addresses, so why did you add them to the file?
>
> greg k-h

Hi Greg,
I re-checked that with the current linux git repository from Linux and
these email addresses are definitively there. I used "git log
--reverse --all --format='...%aN;%aE;%cN;cE' and dumped the full
history into a file. From there I analyze the file further with a
small script that gets all email addresses out of the dump and more or
less does a "uniq" call on names and mails giving an overview who used
which alias.

It seems as if the "@...kroa.org" addresses where just used when you
acted as a "committer" not as "author". Maybe that's the reason why
they never showed up in the commit logs?

I added them since they were used/ I found them in git log and because
they have a TLD (.org) - so I assumed that these are working
addresses.
