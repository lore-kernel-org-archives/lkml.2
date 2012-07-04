Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756483Ab2GDHuN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jul 2012 03:50:13 -0400
Received: from mail-qa0-f53.google.com ([209.85.216.53]:59600 "EHLO
	mail-qa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751256Ab2GDHuJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jul 2012 03:50:09 -0400
MIME-Version: 1.0
In-Reply-To: <20120704074049.GA380@polaris.bitmath.org>
References: <1341341621-15560-1-git-send-email-miletus@chromium.org>
 <4FF35597.7020408@canonical.com> <20120704074049.GA380@polaris.bitmath.org>
From: Daniel Kurtz <djkurtz@chromium.org>
Date: Wed, 4 Jul 2012 15:49:47 +0800
X-Google-Sender-Auth: PNPVuC-p-TNAs1bc4fQOZ3Yl0nQ
Message-ID: <CAGS+omDHQkWdmETOwaDu3nkAQEhJeNkLDdDmF+4N=XDTO6+FWg@mail.gmail.com>
Subject: Re: [PATCH 1/2 v2] HID: magicmouse: Removing report_touches switch
To: Henrik Rydberg <rydberg@euromail.se>
Cc: Chase Douglas <chase.douglas@canonical.com>,
        Yufeng Shen <miletus@chromium.org>, linux-input@vger.kernel.org,
        Jiri Kosina <jkosina@suse.cz>, linux-kernel@vger.kernel.org,
        Andrew de los Reyes <adlr@chromium.org>
Content-Type: text/plain; charset=ISO-8859-1
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 4, 2012 at 3:40 PM, Henrik Rydberg <rydberg@euromail.se> wrote:
> On Tue, Jul 03, 2012 at 01:27:03PM -0700, Chase Douglas wrote:
>> On 07/03/2012 11:53 AM, Yufeng Shen wrote:
>> >Remove the report_touches switch as it is not so useful to turn
>> >off reporting touch events for a touch device. Let the userspace
>> >to do the filtering if the turning off is needed.
>> >
>> >V2: Remove report_touches as suggeted by Chase Douglas
>> >
>> >Signed-off-by: Yufeng Shen <miletus@chromium.org>
>>
>> Acked-by: Chase Douglas <chase.douglas@canonical.com>
>
> Hi Chase,
>
> While testing the new patches, I noticed that only four fingers would
> come through; a fifth finger would make everything freeze. This
> behavior is also present without the new patches. Didn't we have ten
> fingers working at some point?
>
> Cheers,
> Henrik

Hi Henrik,

What Bluetooth host controller are you using?
Which part are you testing (Magic TP or mouse)?

I've been trying to test these patches on a Magic Trackpad using two
computers, with two different ath3k parts.
On one of them, the BT communication freezes immediately after the
first report with 3 fingers.
On the other, it reports all 10 fingers, just fine.

The only difference I can tell is the version of the Atheros Bluetooth chip.

What does your freeze look like?

-Dan
