Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754566Ab2EPPWJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 May 2012 11:22:09 -0400
Received: from mail-yw0-f46.google.com ([209.85.213.46]:47989 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754161Ab2EPPWF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 May 2012 11:22:05 -0400
MIME-Version: 1.0
In-Reply-To: <20120516150813.GA3293@kroah.com>
References: <CAFU-uVs_Gwacxj74cyekY2gv+zAq+Spba7nfPLdTc_dR3y8CYw@mail.gmail.com>
 <20120516143830.GA483@kroah.com> <alpine.LNX.2.00.1205161640520.8796@pobox.suse.cz>
 <CAFU-uVt94sgzq7DgsgKL2OJ0e7DazvNpFunx7BNEz88LHJOg+g@mail.gmail.com> <20120516150813.GA3293@kroah.com>
From: Philipp Riemer <ruderphilipp@gmail.com>
Date: Wed, 16 May 2012 17:21:43 +0200
Message-ID: <CAFU-uVvzyN0asmReOVJcAEiAtbQ=styfGxRRbnrJKgNFDS5X_g@mail.gmail.com>
Subject: Re: [GIT PULL] new mailmap file for the linux kernel git repository
To: Greg KH <gregkh@linuxfoundation.org>
Cc: Jiri Kosina <jkosina@suse.cz>, Paul Mundt <lethal@linux-sh.org>,
        =?ISO-8859-1?Q?Michael_B=FCsc?= =?ISO-8859-1?Q?h?= <m@bues.ch>,
        Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>,
        =?ISO-8859-1?Q?Uwe_Kleine=2DK=F6nig?= 
	<u.kleine-koenig@pengutronix.de>,
        LKML <linux-kernel@vger.kernel.org>, Wang Chen <ellre923@gmail.com>,
        Jonathan Corbet <corbet@lwn.net>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2012/5/16 Greg KH <gregkh@linuxfoundation.org>:
> On Wed, May 16, 2012 at 05:01:39PM +0200, Philipp Riemer wrote:
>> 2012/5/16 Jiri Kosina <jkosina@suse.cz>:
>> > On Wed, 16 May 2012, Greg KH wrote:
>> >
>> >> > In my work I considered the following aspects:
>> >> > * Typos in names
>> >> > * Typos in mails
>> >> > * Mapping of ambiguous mail adresses (e.g. {aa@bb.cc, aa@home.bb.cc,
>> >> > aa@laptop.bb.cc,...} becomes {aa@bb.cc})
>> >> > * Mapping of names to entries with only email information
>> >> > * Harmonization of position and style of last name (no more all-caps
>> >> > names like "First LAST" or those of "Last, First")
>> >> > * No initials in names if not necessary
>> >> > * Conversion of email addresses to lower case
>> >> >
>> >> > Why did I do this? One reason for that is a missing configuration of
>> >> > Git -- leading to a combination of the name of user (login) and
>> >> > computer (e.g. "me@mybox.local"). Of course this is not a real mail
>> >> > address and most users realize and fix this fact pretty fast.
>> >> > Nevertheless there is at least one commit with wrong data in the
>> >> > codebase. Another reason is spelling. When skimming through the vast
>> >> > list of author names and email addresses one can find many
>> >> > typographical errors such as ".con" instead of ".com" or missing
>> >> > letters. Over time also these get fixed -- but the wrong data is
>> >> > visible.
>> >> >
>> >> > I am pretty confident that I coalesced the data of most of the
>> >> > ambiguous users. But despite having spent so many hours in finding and
>> >> > matching these entries, this work (that I did primarily for my thesis)
>> >> > might be helpful for other researchers as well, such as e.g. Wang Chen
>> >> > as the maintainer of the Linux Kernel Patch Statistic
>> >> > <http://www.remword.com/kps_result/> or Greg, Jonthan, etc. as the
>> >> > authors of "Who writes Linux"
>> >> > <http://go.linuxfoundation.org/who-writes-linux-2012>...
>> >> >
>> >> > Hence, please integrate this file into the official Linux Kernel repository.
>> >>
>> >> You forgot a signed-off-by: line which is required for a patch to be
>> >> accepted :(
>> >
>> > While Greg is at this, the changelogs also really don't really follow the
>> > kernel changelog standards (line wrapping, etc.).
>> >
>> > --
>> > Jiri Kosina
>> > SUSE Labs
>>
>> Thank you both for your fast feedback. I really appreciate it.
>>
>> Since this is my first contribution to the Linux Kernel I am not
>> pretty sure what I have to do. Is there anywhere a guideline how I get
>> a "signed-off"? I sent the mail to the addresses I found via
>> `scripts/get_maintainer.pl -f .mailmap` since I expected those people
>> to be somehow interested in this file. What other steps can I take?
>
> Please read the file, Documentation/SubmittingPatches for what the line,
> "Signed-off-by:" means and what you are agreeing to there, as well as
> how to properly submit a patch for inclusion in the kernel.
>
>> I don't understand the point regarding the changelog standards -- what
>> do you mean with that? I changed the .mailmap file and oriented myself
>> on what was already there... How can I improve the file to fit to the
>> Linux standards? Some hints?
>
> Read the above file :)
>
> Hope this helps,
>
> greg k-h

Will read through the document and than try to re-submit the patch
properly. Thanks for your patience and your fast answers.

Regards,
Philipp
