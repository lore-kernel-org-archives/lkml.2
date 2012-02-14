Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759956Ab2BNTSd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Feb 2012 14:18:33 -0500
Received: from mail-gx0-f174.google.com ([209.85.161.174]:65278 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757069Ab2BNTSa convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Feb 2012 14:18:30 -0500
MIME-Version: 1.0
In-Reply-To: <CAE2SPAaY0Svfwo6_i0k9G39WO-vN3OD-o4+o3xnyun1n=PAuMw@mail.gmail.com>
References: <201201151255.41252.roucaries.bastien@gmail.com>
	<CAE2SPAb3Ozk7LHrqE_asazZ7kEogXEH=2S8D5PUprqXZK2o9Ow@mail.gmail.com>
	<m2mx9ev85j.fsf@bob.laptop.org>
	<CAE2SPAbpeHiz_JByYGrMJ6s1_yCM3SaQ8xjx4heuT2_i2Gyxcw@mail.gmail.com>
	<CAE2SPAaY0Svfwo6_i0k9G39WO-vN3OD-o4+o3xnyun1n=PAuMw@mail.gmail.com>
Date: Tue, 14 Feb 2012 11:18:27 -0800
X-Google-Sender-Auth: yK2h_fxRq9qaRQqL-SQx0i_6CRw
Message-ID: <CAE9FiQXdrKZVCFb4zQ7C=B3sGVGLzBdtCgOkkyA9KdKOiqemww@mail.gmail.com>
Subject: Re: Need pci rescan in order to get my mmc reader
From: Yinghai Lu <yinghai@kernel.org>
To: Bastien ROUCARIES <roucaries.bastien@gmail.com>
Cc: Chris Ball <cjb@laptop.org>, linux-kernel@vger.kernel.org,
        linux-pci@vger.kernel.org, linux-mmc@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 14, 2012 at 10:17 AM, Bastien ROUCARIES
<roucaries.bastien@gmail.com> wrote:
> ping **2
>
> On Thu, Jan 26, 2012 at 10:54 AM, Bastien ROUCARIES
> <roucaries.bastien@gmail.com> wrote:
>> On Mon, Jan 23, 2012 at 2:51 PM, Chris Ball <cjb@laptop.org> wrote:
>>> Hi,
>>>
>>> On Mon, Jan 23 2012, Bastien ROUCARIES wrote:
>>>> On Sun, Jan 15, 2012 at 12:55 PM, bastien ROUCARIES
>>>> <roucaries.bastien@gmail.com> wrote:
>>>>> I am hit by the same bug than here
>>>>> https://bugs.launchpad.net/ubuntu/+source/linux/+bug/703180
>>>>>
>>>>> I order to get my mmc reader functionnal I need to put a mmc card
>>>>> and do a pci rescan manualy.
>>>>>
>>>>> What could be done  ?
>>>>>
>>>>> What do you need in order to help ?
>>>>>
>>>>> Thanks
>>>
>>> I'm not sure there's anything I (at the MMC layer) can do to help;
>>> having a visible PCI device is a prerequisite for working MMC.
>>>
>>> Have you tried a recent upstream kernel, and looked for any available
>>> BIOS updates for your laptop?
>>
>> BIOS is lasted and kernel is 3.1.
>>
>> I know that  PCI device is a prerequisite  but I believe it is
>> possible to run some quirk on this laptop, in order to get the mmc
>> reader up earlier.
>>
>> See also https://bugzilla.kernel.org/show_bug.cgi?id=40802

can you post full boot log with pci debug enabled?

CONFIG_PCI_DEBUG=y

and "debug ignore_loglevel" in boot command line.

also post:
lspci -tv
lspci -vvxxx
lspci

should have one booted with card inserted and one booted without card inserted.

Yinghai
