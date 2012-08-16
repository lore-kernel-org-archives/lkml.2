Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933248Ab2HPT6c (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Aug 2012 15:58:32 -0400
Received: from mail-lpp01m010-f46.google.com ([209.85.215.46]:42673 "EHLO
	mail-lpp01m010-f46.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932536Ab2HPT6a (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Aug 2012 15:58:30 -0400
MIME-Version: 1.0
In-Reply-To: <20120816180732.GA451@polaris.bitmath.org>
References: <1344807757-2217-1-git-send-email-rydberg@euromail.se>
	<1344807757-2217-10-git-send-email-rydberg@euromail.se>
	<CAF8JNhLBO72-Rpm7dFWfYLPvbhDZZsm2yOy_7sREnNhTWqZ04w@mail.gmail.com>
	<20120816180732.GA451@polaris.bitmath.org>
Date: Thu, 16 Aug 2012 12:58:28 -0700
Message-ID: <CAF8JNhLurhkKUY1NwaVcyJfK9e2QiakAYg_Cyd1oDqtd-ZrS6Q@mail.gmail.com>
Subject: Re: [PATCH 09/19] Input: MT - Handle frame synchronization in core
From: Ping Cheng <pinglinux@gmail.com>
To: Henrik Rydberg <rydberg@euromail.se>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>, Jiri Kosina <jkosina@suse.cz>,
        linux-input@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 16, 2012 at 11:07 AM, Henrik Rydberg <rydberg@euromail.se> wrote:
> On Wed, Aug 15, 2012 at 04:28:17PM -0700, Ping Cheng wrote:
>> On Sun, Aug 12, 2012 at 2:42 PM, Henrik Rydberg <rydberg@euromail.se> wrote:
>> > Collect common frame synchronization tasks in a new function,
>> > input_mt_sync_frame(). Depending on the flags set, it drops
>> > unseen contacts and performs pointer emulation.
>> >
>> > Signed-off-by: Henrik Rydberg <rydberg@euromail.se>
>>
>> I went through the patchset except those for bcm5974. Since there are
>> changes that affect other drivers, do you plan to update the affected
>> drivers as well?
>
> I am not sure what you mean here? There is a patch with in-kernel api
> changes, which also changes all drivers using the api. Some of those
> drivers will benefit from further changes, but that is a different
> story.

Just to clarify a little bit more. Patch 08/19 was only a generic
update. A complete update should introduce INPUT_MT_POINTER and
INPUT_MT_DIRECT so the drivers can fully utilize the new feature.

Now I understand you expect us to update the "different story".

Thanks.

Ping

Ping
