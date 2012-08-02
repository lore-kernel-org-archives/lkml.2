Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754787Ab2HBNpr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Aug 2012 09:45:47 -0400
Received: from mail-wg0-f44.google.com ([74.125.82.44]:39570 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754449Ab2HBNpq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Aug 2012 09:45:46 -0400
MIME-Version: 1.0
In-Reply-To: <65B6AB74-5658-49F1-BB6F-5A644CC10098@shealevy.com>
References: <1343911533-3423-1-git-send-email-shea@shealevy.com>
	<CANq1E4Tn6nugb0vmMb1VzTE+-io0bV2y7OLaEXtXbav4W51Kag@mail.gmail.com>
	<65B6AB74-5658-49F1-BB6F-5A644CC10098@shealevy.com>
Date: Thu, 2 Aug 2012 15:45:44 +0200
Message-ID: <CANq1E4T1_0heb+K49-kJYwsqLNusyc-Vc-YsWrP_3gBEVe4C2w@mail.gmail.com>
Subject: Re: [PATCH] Bluetooth: Add support for Apple MacBook Pro 9,2
From: David Herrmann <dh.herrmann@googlemail.com>
To: Shea Levy <shea@shealevy.com>
Cc: Marcel Holtmann <marcel@holtmann.org>,
        Gustavo Padovan <gustavo@padovan.org>,
        Johan Hedberg <johan.hedberg@gmail.com>,
        "linux-bluetooth@vger.kernel.org" <linux-bluetooth@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Shea

On Thu, Aug 2, 2012 at 3:39 PM, Shea Levy <shea@shealevy.com> wrote:
> Hi David,
>
> On Aug 2, 2012, at 9:32 AM, David Herrmann <dh.herrmann@googlemail.com> wrote:
>
>> Hi Shea
>>
>> On Thu, Aug 2, 2012 at 2:45 PM,  <shea@shealevy.com> wrote:
>>> From: Shea Levy <shea@shealevy.com>
>>>
>>>
>>> Signed-off-by: Shea Levy <shea@shealevy.com>
>>
>> Why is this patch missing a commit-message? Please add one.
>
> The commit message was only one line, which git-send-email puts in the subject.

I know that. But I prefer non-empty commit-message bodies. Well, maybe
I am the only one ;)

>> And also
>> include the output of "usb-devices" or the contents of
>> /sys/kernel/debug/usb/devices in this commit-message.
>>
>
> OK. The whole thing or just the relevant bits? Does it matter if I'm booted into the patched kernel or not?

Just copy the output of the relevant parts, that is, the one for your
device. It is used by the maintainer to validate that there was no
copy/paste mistake. It doesn't matter if booted with or without the
patch.

Thanks
David
