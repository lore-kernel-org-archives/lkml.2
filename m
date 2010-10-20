Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755985Ab0JTWl5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Oct 2010 18:41:57 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:32777 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755507Ab0JTWl4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Oct 2010 18:41:56 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=PYUvBVOLlIRqLQf8ALtEe3hsejSN7EAMOXApwSSq4libkVytlekXrN0XKEliIEZjXM
         c697APF+bUxl5Zbxg5VqSg0VqJ0RdG2zDhEAEXIbU1pzLQlGOBTCd0B/Pc8Psn62QFFr
         1Yo1PH6mYQPvD7SxO76SsfrahtWGFGxxmAw/4=
MIME-Version: 1.0
In-Reply-To: <20101020211710.GB10006@suse.de>
References: <1287608139-21354-1-git-send-email-alchark@gmail.com>
	<1287608139-21354-4-git-send-email-alchark@gmail.com>
	<20101020211710.GB10006@suse.de>
Date: Thu, 21 Oct 2010 02:41:54 +0400
Message-ID: <AANLkTikhuW8+bKi8CS59Byrv8XRE6iKCiegc3ZcyCJnW@mail.gmail.com>
Subject: Re: [PATCH 4/6] usb: Add support for VIA VT8500 and compatibles in
 EHCI HCD
From: Alexey Charkov <alchark@gmail.com>
To: Greg KH <gregkh@suse.de>
Cc: vt8500-wm8505-linux-kernel@googlegroups.com,
        linux-arm-kernel@lists.infradead.org,
        David Brownell <dbrownell@users.sourceforge.net>,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2010/10/21 Greg KH <gregkh@suse.de>:
> On Thu, Oct 21, 2010 at 12:55:36AM +0400, Alexey Charkov wrote:
>> VIA and WonderMedia Systems-on-Chip feature a standard EHCI host
>> controller. This adds necessary glue to use the standard driver
>> with these systems.
>>
>> Signed-off-by: Alexey Charkov <alchark@gmail.com>
>> ---
>>
>> Please review and state whether this could be acceptable for a merge
>> to mainline in the coming 2.6.37 window. If possible, I would deeply
>> appreciate a merge to a relevant git tree for integration prior to
>> asking Linus to pull the changes. I could rebase the code if needed,
>> currently this is against Linus' master branch.
>>
>> This patch relies on the basic architecture support for VT8500/WM8505
>> to be in place, as introduced by PATCH 1/6 in this series.
>
> Will this code fail to build without that patch?
>

As all the additions are ifdef-ed, it won't unless somebody manually
defines CONFIG_ARCH_VT8500. But in that case the person should
probably know what (s)he is doing.
