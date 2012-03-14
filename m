Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753844Ab2CNACO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Mar 2012 20:02:14 -0400
Received: from mail-gx0-f174.google.com ([209.85.161.174]:58006 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753546Ab2CNACN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Mar 2012 20:02:13 -0400
MIME-Version: 1.0
X-Originating-IP: [2620:0:1000:1b02:1aa9:5ff:fe24:37a9]
In-Reply-To: <201203132242.07283.rjw@sisk.pl>
References: <201203092155.04731.rjw@sisk.pl>
	<201203131939.36186.arnd@arndb.de>
	<201203132117.50390.rjw@sisk.pl>
	<201203132242.07283.rjw@sisk.pl>
Date: Tue, 13 Mar 2012 17:02:12 -0700
Message-ID: <CAOesGMi9uQyS=ATE+wXZY8hP-1+-uZhW2B-Y3zV9fOEBCYUFVw@mail.gmail.com>
Subject: Re: [GIT PULL] Renesas SoC updates for v3.4, take 2
From: Olof Johansson <olof@lixom.net>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Arnd Bergmann <arnd@arndb.de>, LKML <linux-kernel@vger.kernel.org>,
        Magnus Damm <magnus.damm@gmail.com>,
        Linux-sh list <linux-sh@vger.kernel.org>,
        "arm@kernel.org" <arm@kernel.org>, Paul Mundt <lethal@linux-sh.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 13, 2012 at 2:42 PM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
> On Tuesday, March 13, 2012, Rafael J. Wysocki wrote:
>> On Tuesday, March 13, 2012, Arnd Bergmann wrote:
>> > On Tuesday 13 March 2012, Rafael J. Wysocki wrote:
>> > > > Note that the __io() issue has turned out to be more urgent than I first
>> > > > thought when we discussed it, so it would be good to apply the patch below
>> > > > on top of your series.
>> > >
>> > > Do you want me to apply it now or will you do that in your tree?
>> >
>> > Doesn't matter to me, as long as one of you applies it ;-)
>>
>> OK, so I will add it to the soc branch in the Renesas tree.
>
> Applied and pushed back the updated tree.

Seems like you applied the patch but without the subject line, so now
git thinks the whole first paragraph is the patch subject. That's a
bit messy and I'd prefer if you could fix it up.

Do you have downstream users of your tree that you'll mess up if you
rebase the last commit though? Alternatively I can take everything on
the branch but the last patch and apply it myself, but that will still
cause trouble for your downstream developers once things go upstream
and come down.


-Olof
