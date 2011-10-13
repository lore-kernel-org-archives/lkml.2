Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753332Ab1JMHIk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Oct 2011 03:08:40 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:50356 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753258Ab1JMHIh convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Oct 2011 03:08:37 -0400
MIME-Version: 1.0
In-Reply-To: <20111006181220.GA15950@khazad-dum.debian.net>
References: <1300181106-20219-1-git-send-email-keng-yu.lin@canonical.com>
 <20110316185755.GC7918@khazad-dum.debian.net> <CADXHx7b36g1+vo9cjuiq7VnjN3LWiwQtgepHjGU1P74ZsdtwQw@mail.gmail.com>
 <20111006181220.GA15950@khazad-dum.debian.net>
From: =?UTF-8?B?S2VuZy1Zw7wgTGlu?= <kengyu@canonical.com>
Date: Thu, 13 Oct 2011 15:07:56 +0800
X-Google-Sender-Auth: THA6Fzy3TsY9hJLOdiO30cAIx3Y
Message-ID: <CADXHx7YFJYvd6K0Djqabxs6kyPJU5YjEGTBTvrMVmFdLirF5rA@mail.gmail.com>
Subject: Re: [ibm-acpi-devel] [PATCH] thinkpad-acpi: disable alsa volume mixer
 for SL410/SL510
To: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
Cc: ibm-acpi-devel@lists.sourceforge.net, platform-driver-x86@vger.kernel.org,
        Henrique de Moraes Holschuh <ibm-acpi@hmh.eng.br>,
        linux-kernel@vger.kernel.org, Matthew Garrett <mjg@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 7, 2011 at 2:12 AM, Henrique de Moraes Holschuh
<hmh@hmh.eng.br> wrote:
> On Thu, 06 Oct 2011, Keng-Yü Lin wrote:
>> On Thu, Mar 17, 2011 at 2:57 AM, Henrique de Moraes Holschuh
>> <hmh@hmh.eng.br> wrote:
>> > On Tue, 15 Mar 2011, Keng-Yu Lin wrote:
>> >> The mute key on SL410/SL510 only works when the alsa volume mixer
>> >> is not enabled. This patch makes the alsa volume mixer disabled
>> >> on the matched SL410/SL510 EC versions.
>> >
>> > I'd like more data on this.  Is this some sort of weird interaction with
>> > userspace, or does the firmware actually changes behaviour when we
>> > enable the MUTE HKEY event in the event mask?
>>
>> The firmware does not change its behaviour with the key enabled in the keymask.
>> The mute key (and the LED on it) of the two models works good without
>> thinkpad_acpi loaded. So in the patch I like to exclude the volume
>> control part for the two models.
>
> If the firmware does not change behaviour, doesn't that mean the bug is
> elsewhere?
>
> Is the firmware reporting these keys somewhere else (e.g. through the
> keyboard)?
>

As the users reported in https://launchpad.net/bugs/595896, there is
no KEY_MUTE either from thinkpad_acpi nor the keyboard when pressing
the mute hotkey. (I do not really possess the hardware. but just
debugged/helped remotely).

It will be really appreciated if there is any suggestion/insight for
looking into the bug.  At the moment I can just find this fix for the
issue.
