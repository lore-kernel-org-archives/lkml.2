Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751925Ab1G3NDk (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Jul 2011 09:03:40 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:43335 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751488Ab1G3NDg convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Jul 2011 09:03:36 -0400
MIME-Version: 1.0
In-Reply-To: <87bowcyvtj.fsf@rho.meyering.net>
References: <CAPweEDzv+vByC1s2bWRjVQdVLqw4Xf2sUf_CQgVync_YcxtdvQ@mail.gmail.com>
	<20110725134533.GA23781@citd.de>
	<CAPweEDybuOpPVidJWg+rfs8rU8y=xo4d3H=P7XQJh_DiKrF4DQ@mail.gmail.com>
	<20110729195904.GC1720@ucw.cz>
	<20110729213156.GA32685@citd.de>
	<4E33397F.4010908@draigBrady.com>
	<87bowcyvtj.fsf@rho.meyering.net>
Date: Sat, 30 Jul 2011 14:03:34 +0100
X-Google-Sender-Auth: sR0XtzQOdgXXpW048dErfhhVb04
Message-ID: <CAPweEDzExzvt+G7_3UanFM+PJEpsuOh8Qnu-YRanNo+Bm-0o5w@mail.gmail.com>
Subject: Re: ext3 hacked filesystem (by debian exim4 exploit) available for
 analysis and bugreporting
From: Luke Kenneth Casson Leighton <lkcl@lkcl.net>
To: Jim Meyering <jim@meyering.net>
Cc: =?UTF-8?Q?P=C3=A1draig_Brady?= <P@draigbrady.com>,
        Matthias Schniedermeyer <ms@citd.de>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Pavel Machek <pavel@ucw.cz>, Coreutils <coreutils@gnu.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jul 30, 2011 at 10:14 AM, Jim Meyering <jim@meyering.net> wrote:
> Pádraig Brady wrote:
> ...
>> `strace lsattr ...` shows it calls ioctl (...FS_IOC_GETFLAGS...)
>> So there would be overhead.
>> The output of ls is fairly constrained too for compat reasons.

 well if that rule has been broken once for selinux (adding extra
symbols) then it can be broken again.

> One way by which ls -l could inform us that a file has
> "attributes" like that would be via what POSIX calls the
> "optional alternate access method flag".  Currently,
> it can be a space, a "+", or a ".":

 i'd advocate, when the ls --color option is set, changing the
background to something attention-grabbing (e.g. red).  it's far too
easy to miss an extra symbol otherwise, and "+", although intuitively
saying "there's more than meets the eye, here" is too similar to a
line of "-"s to really make people sit up and take notice.  i'd
certainly go "oh look, there's a +, how pretty", but a + on a red
background i might just stop and think, "eh? i no unnerstan, let's
look up man page or call some friends".

 l.
