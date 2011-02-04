Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752878Ab1BDXm7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Feb 2011 18:42:59 -0500
Received: from mail-gw0-f46.google.com ([74.125.83.46]:41748 "EHLO
	mail-gw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751085Ab1BDXm5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Feb 2011 18:42:57 -0500
Message-ID: <4D4C8EFA.40207@landley.net>
Date: Fri, 04 Feb 2011 17:42:50 -0600
From: Rob Landley <rob@landley.net>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20101208 Thunderbird/3.1.7
MIME-Version: 1.0
To: Randy Dunlap <rdunlap@xenotime.net>
CC: Ulf Magnusson <ulfalizer.lkml@gmail.com>, linux-kbuild@vger.kernel.org,
        zippel@linux-m68k.org, mmarek@suse.cz, akpm@linux-foundation.org,
        andrea.gelmini@gelma.net, linux-kernel@vger.kernel.org,
        linux-doc@vger.kernel.org
Subject: Re: [PATCH] [ANNOUNCE] kconfig: Kconfiglib: a flexible Python Kconfig
 parser
References: <20110201232750.GA30800@ulf> <20110204143529.f49e92e5.rdunlap@xenotime.net>
In-Reply-To: <20110204143529.f49e92e5.rdunlap@xenotime.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/04/2011 04:35 PM, Randy Dunlap wrote:
>> The patch should be preferably be applied to a recent kernel, i.e. Linus's
>> (2.6.38-rc3 at the time of writing).  Due to recent Kconfig changes, the
>> kconfigtest.py test suite - which compares output character-for-character -
>> will indicate failure on older (a few months old) kernels versions even though
>> the outputs are functionally equivalent.
>>
>>  Documentation/kbuild/kconfig-language.txt |    5 +
>>  Documentation/kbuild/kconfig.txt          |    8 +
>>  README                                    |   13 +
>>  scripts/kconfig/Makefile                  |   26 +-
>>  scripts/kconfig/kconfiglib.py             | 3918 +++++++++++++++++++++++++++++
>>  scripts/kconfig/kconfigtest.py            |  396 +++
>>  6 files changed, 4365 insertions(+), 1 deletions(-)
>>  create mode 100644 scripts/kconfig/kconfiglib.py
>>  create mode 100644 scripts/kconfig/kconfigtest.py

Wait, I thought this was an extra standalone library.  Are you saying
you want to make it so Linux will no longer compile on a build machine
that doesn't have Python installed?

If this is merely an extra developer tool ala bloat-o-meter and
checkpatch.pl then it's merely uninteresting to me.  (I myself wrote a
quick and dirty http://kernel.org/doc/make/menuconfig2html.py to
generate http://kernel.org/doc/menuconfig/x86.html and friends years
ago, and I still run it to update that once in a while.  There's not
much to it.)

But adding new prerequities to a build machine would be really annoying
for my use cases.

Rob
