Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753692Ab1GHPuw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jul 2011 11:50:52 -0400
Received: from mail-vw0-f46.google.com ([209.85.212.46]:56506 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750847Ab1GHPuu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jul 2011 11:50:50 -0400
MIME-Version: 1.0
In-Reply-To: <201107072306.02708.rjw@sisk.pl>
References: <1309702581-16863-1-git-send-email-akinobu.mita@gmail.com>
	<20110703171539.GF21127@elf.ucw.cz>
	<CAC5umyibWo===0Lr5Wz2moOvnf0qiAvFLo4--sLCRmx4sJrdRA@mail.gmail.com>
	<201107072306.02708.rjw@sisk.pl>
Date: Sat, 9 Jul 2011 00:50:48 +0900
Message-ID: <CAC5umyhZ35AXtwA=Uy1+zp9N=NwLths=h6jKUK53f0U+tZMZZA@mail.gmail.com>
Subject: Re: [PATCH 1/7] pm: improve error code of pm_notifier_call_chain()
From: Akinobu Mita <akinobu.mita@gmail.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Pavel Machek <pavel@ucw.cz>, linux-kernel@vger.kernel.org,
        akpm@linux-foundation.org, linux-pm@lists.linux-foundation.org,
        Jiri Kosina <jkosina@suse.cz>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Heiko Carstens <heiko.carstens@de.ibm.com>, linux390@de.ibm.com,
        linux-s390@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2011/7/8 Rafael J. Wysocki <rjw@sisk.pl>:
> On Monday, July 04, 2011, Akinobu Mita wrote:
>> 2011/7/4 Pavel Machek <pavel@ucw.cz>:
>> > On Sun 2011-07-03 23:16:15, Akinobu Mita wrote:
>> >> This enables pm_notifier_call_chain() to get the actual error code
>> >> in the callback rather than always assume -EINVAL by converting all
>> >> PM notifier calls to return encapsulate error code with
>> >> notifier_from_errno().
>> >>
>> >> Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
>> >> Cc: Pavel Machek <pavel@ucw.cz>
>> >
>> > Nothing obviously wrong here.
>>
>> Thanks. Can I add your ACK for this patch?
>
> Do you want me to take this patch?

Yes, please merge it to your tree.
