Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759028Ab1KWHhw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Nov 2011 02:37:52 -0500
Received: from mail-fx0-f46.google.com ([209.85.161.46]:34606 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752385Ab1KWHht convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Nov 2011 02:37:49 -0500
MIME-Version: 1.0
In-Reply-To: <CA+55aFyy19VYSdZW0+jNxAb8ix0xpX2j9YFw9oQi3jm3+mDEvw@mail.gmail.com>
References: <lx6sezwGldO.A.IhF.UBpWOB@chimera>
	<201111212249.31196.rjw@sisk.pl>
	<CA+55aFyy19VYSdZW0+jNxAb8ix0xpX2j9YFw9oQi3jm3+mDEvw@mail.gmail.com>
Date: Wed, 23 Nov 2011 08:37:45 +0100
Message-ID: <CACna6rzQhp4DXonK_Mr+Od9yMQJtr24Z5TE27VxhcMrcY4u+EA@mail.gmail.com>
Subject: Re: 3.2-rc2+: Reported regressions from 3.0 and 3.1
From: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
To: Linus Torvalds <torvalds@linux-foundation.org>,
        stephen hemminger <shemminger@vyatta.com>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Maciej Rutecki <maciej.rutecki@gmail.com>,
        Florian Mickler <florian@mickler.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Kernel Testers List <kernel-testers@vger.kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        Linux ACPI <linux-acpi@vger.kernel.org>,
        Linux PM List <linux-pm@lists.linux-foundation.org>,
        Linux SCSI List <linux-scsi@vger.kernel.org>,
        Linux Wireless List <linux-wireless@vger.kernel.org>,
        DRI <dri-devel@lists.freedesktop.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

W dniu 21 listopada 2011 23:22 użytkownik Linus Torvalds
<torvalds@linux-foundation.org> napisał:
> On Mon, Nov 21, 2011 at 1:49 PM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
>>
>> Subject    : [3.1-rc8 REGRESSION] sky2 hangs machine on turning off or suspending
>> Submitter  : Rafał Miłecki <zajec5@gmail.com>
>> Date       : 2011-11-09 11:46
>> Message-ID : CACna6ryTdLcWVYgHu=_mRFga1sFivpE_DyZOY-HMmKggkWAJAw@mail.gmail.com
>> References : http://marc.info/?l=linux-netdev&m=132083922228088&w=4
>
> This should be fixed by commit 1401a8008a09 ("sky2: fix hang on
> shutdown (and other irq issues)") in current -git.

This patch doesn't fix my hang.

However git contains also:
sky2: fix hang in napi_disable
This is the one fixing my case.

So the bug is resolved, however I'm a little disappointed noone
ping-ed me about that patches. I've spent some time on bisecting this
issue, expected to get some response :/

-- 
Rafał
