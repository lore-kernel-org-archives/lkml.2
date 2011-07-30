Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751936Ab1G3M6y (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Jul 2011 08:58:54 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:52540 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751391Ab1G3M6s convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Jul 2011 08:58:48 -0400
MIME-Version: 1.0
In-Reply-To: <20110729195904.GC1720@ucw.cz>
References: <CAPweEDzv+vByC1s2bWRjVQdVLqw4Xf2sUf_CQgVync_YcxtdvQ@mail.gmail.com>
	<20110725134533.GA23781@citd.de>
	<CAPweEDybuOpPVidJWg+rfs8rU8y=xo4d3H=P7XQJh_DiKrF4DQ@mail.gmail.com>
	<20110729195904.GC1720@ucw.cz>
Date: Sat, 30 Jul 2011 13:58:46 +0100
X-Google-Sender-Auth: aVa6JdDydPWRZw0Meu4UQ8X1hRc
Message-ID: <CAPweEDygbhQY8F7fzfY8LLOYHDJX+b06zXbrVxNSkMZBw8mbQg@mail.gmail.com>
Subject: Re: ext3 hacked filesystem (by debian exim4 exploit) available for
 analysis and bugreporting
From: Luke Kenneth Casson Leighton <lkcl@lkcl.net>
To: Pavel Machek <pavel@ucw.cz>
Cc: Matthias Schniedermeyer <ms@citd.de>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 29, 2011 at 8:59 PM, Pavel Machek <pavel@ucw.cz> wrote:
> On Mon 2011-07-25 22:08:24, Luke Kenneth Casson Leighton wrote:
> [...]
>> On Mon, Jul 25, 2011 at 2:45 PM, Matthias Schniedermeyer <ms@citd.de> wrote:
>>> You did try lsattr and checked that the files aren't 'immutable'?
>>
>>  i didn't! :)  didn't know about (but should have guessed) ext3
>> attributes.  they are indeed - thank you matthias.
>> [...]

> Should ls -l be moddified to show something when file has immutable
> (and friends) set?
>                                                                Pavel

 +1 on that.  i've been using unix systems for 20 years, and had
absolutely no visual clue that there were ext3 attributes, from doing
"ls -altr", my usual "fingers-pre-programmed" command.

 i would say that something like "+" on the attributes -rwxrwx---+
would intuitively say "there's more!" but it would be very helpful for
its background to e.g. be in red [on ls --color].  that would
definitely grab peoples' attention in a "wtf is that??" way.

 yeah. whatever symbol is chosen, i believe that some sort of
eye-burning background colour would be more important, forcing people
to go "ls --help" or "man ls".

 my only concern with adding yet more attribute-markers is all the
commands that parse "ls -a" output.  well... t'be'honest... i think if
selinux attribute markers have already been added, then that bullet
has already been bitten once, so it's not as big a hairy deal as all
that.

peace.

l.
