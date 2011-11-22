Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755068Ab1KVHQt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Nov 2011 02:16:49 -0500
Received: from mail-yx0-f174.google.com ([209.85.213.174]:34623 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752401Ab1KVHQr convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Nov 2011 02:16:47 -0500
MIME-Version: 1.0
In-Reply-To: <CALCETrUpXrsjBLZsZU3u+y7KCDO0LW55QoBQkBqN_BPFZHsrkw@mail.gmail.com>
References: <lx6sezwGldO.A.IhF.UBpWOB@chimera> <201111212249.31196.rjw@sisk.pl>
 <CA+55aFwAELQieN=qR7Gz_MT5rHPp90H10uTMS+DOJjefk7q3ng@mail.gmail.com> <CALCETrUpXrsjBLZsZU3u+y7KCDO0LW55QoBQkBqN_BPFZHsrkw@mail.gmail.com>
From: Andy Lutomirski <luto@amacapital.net>
Date: Mon, 21 Nov 2011 23:16:25 -0800
Message-ID: <CALCETrXP63VYU6mvxuUJKq7uJ-a3LG6c4t6asQFGUsJnrP6_ow@mail.gmail.com>
Subject: Re: 3.2-rc2+: Reported regressions from 3.0 and 3.1
To: Linus Torvalds <torvalds@linux-foundation.org>
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
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 21, 2011 at 2:34 PM, Andy Lutomirski <luto@amacapital.net> wrote:
> On Mon, Nov 21, 2011 at 2:11 PM, Linus Torvalds
> <torvalds@linux-foundation.org> wrote:
>> On Mon, Nov 21, 2011 at 1:49 PM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
>>>
>>> Subject    : [3.1 REGRESSION] Commit 5cec93c216db77c45f7ce970d46283bcb1933884 breaks the Chromium seccomp sandbox
>>> Submitter  : Nix <nix@esperi.org.uk>
>>> Date       : 2011-11-14 0:40
>>> Message-ID : 8762inleno.fsf@spindle.srvr.nix
>>> References : http://marc.info/?l=linux-kernel&m=132123396226377&w=2
>>

This is apparently fixed in seccompsandbox.  See:

https://code.google.com/p/seccompsandbox/issues/detail?id=17
https://code.google.com/p/seccompsandbox/source/detail?r=178

Unless someone objects, I'll consider this to not be a kernel
regression worth fixing.

--Andy
