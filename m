Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756707Ab2BGIjV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Feb 2012 03:39:21 -0500
Received: from mail-vw0-f46.google.com ([209.85.212.46]:64302 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756586Ab2BGIjT convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Feb 2012 03:39:19 -0500
MIME-Version: 1.0
X-Originating-IP: [87.66.62.139]
In-Reply-To: <201202062116.16744.rjw@sisk.pl>
References: <1328227065-22045-1-git-send-email-venki@google.com>
	<CAORVsuVCYp+Fmfaje-UDnv1=x0PqApML6Jb-Z6EG0425SuREMg@mail.gmail.com>
	<CAORVsuW7mBCZdGqScX5jjaYDhijZH_H7vDKkJ4v6WWHn9rUsGw@mail.gmail.com>
	<201202062116.16744.rjw@sisk.pl>
Date: Tue, 7 Feb 2012 09:39:19 +0100
Message-ID: <CAORVsuWgAgxgJ2ej0psZb1OKN8SE39PF2URdikWzVHJzUMKQMA@mail.gmail.com>
Subject: Re: [linux-pm] [PATCH] CPU C-state breakage with PM Qos change
From: Jean Pihet <jean.pihet@newoldbits.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>, Venkatesh Pallipadi <venki@google.com>
Cc: markgross@thegnar.org, Kevin Hilman <khilman@ti.com>,
        linux-kernel@vger.kernel.org,
        Linux PM mailing list <linux-pm@lists.linux-foundation.org>,
        "Pihet-XID, Jean" <j-pihet@ti.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 6, 2012 at 9:16 PM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
> On Monday, February 06, 2012, Jean Pihet wrote:
>> Rafael,
>>
>> On Mon, Feb 6, 2012 at 11:18 AM, Jean Pihet <jean.pihet@newoldbits.com> wrote:
>> > Hi Rafael, Mark,
>> >
>> > On Sun, Feb 5, 2012 at 12:04 PM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
>> ...
>>
>> >> In kernel/power/Makefile:
>> >>
>> >> obj-$(CONFIG_PM)                += main.o qos.o
>> >>
>> >> I guess that explains things. :-)
>> > Initially I thought we should have a way of disabling the feature on
>> > some (minimal) kernels and so thought CONFIG_PM was the option to use.
>> >
>> >> It's quite easy to make qos.o be independent of CONFIG_PM, in which case the
>> >> code added by Venki can be removed, so patches welcome (for 3.4, though).
>> > I am working on it, more to come soon.
>>
>> I have a couple of patches ready, to be applied on 3.3-rc1 (so without
>> Venki's patch applied).
>> The first one is on PM QoS, the second one on per-device PM QoS. Is
>> the latter needed?
>
> I'm not sure without looking. :-)
That makes sense ;p

Just sent out the patch set as '[PATCH 0/2] PM / QoS: unconditionally
build the feature'.
It has been compile tested only using the i386 defconfig, with and
without CONFIG_PM.

It requires some more testing on x86.
Venki, can you check it out if this fixes the initial problem?

>
> Thanks,
> Rafael

Regards,
Jean
