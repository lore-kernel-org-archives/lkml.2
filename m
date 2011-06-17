Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755818Ab1FQVkY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Jun 2011 17:40:24 -0400
Received: from mail-qy0-f174.google.com ([209.85.216.174]:41238 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751519Ab1FQVkW convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Jun 2011 17:40:22 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=tLN2dWhY9Net8XMTWV4cCNBgofeAAYgLq/mUIaMIzMdJyg1bW0FA+cRCqQfZs1tlFr
         Td6HG+ZnMbsG3cM3Suc95gT/FFosBtCtZixVacnbyRzZGUO1gIlos79J4wNPvhKzfhxP
         aaVwHn6FZ8gfkqp46e0sAiLUdXHXg37nvqGR8=
MIME-Version: 1.0
In-Reply-To: <BANLkTik+yr5gp8TW09-+RbOYnc5RQJ7K0g@mail.gmail.com>
References: <BANLkTin8b2suL1675DKvHbeXuCzeCFJeOg@mail.gmail.com>
	<BANLkTin-iYMvbuq=DGo8JZa_vYUMsd24jQ@mail.gmail.com>
	<BANLkTi=NYq7wFqGFuiM_QUtpEZDS5pAuUQ@mail.gmail.com>
	<BANLkTikiszrsC7n-31yUXpMEKHTbWamabw@mail.gmail.com>
	<BANLkTik+yr5gp8TW09-+RbOYnc5RQJ7K0g@mail.gmail.com>
Date: Fri, 17 Jun 2011 14:40:21 -0700
Message-ID: <BANLkTinEhyN-i0N9QRpdjMUTpMCRiDMDdw@mail.gmail.com>
Subject: Re: New Gentoo install on Intel Z68/i7-2600K system hangs after
 VFS:Mounted root...
From: Mark Knecht <markknecht@gmail.com>
To: Paul Hartman <paul.hartman@gmail.com>
Cc: Linux Kernel List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 17, 2011 at 12:01 PM, Mark Knecht <markknecht@gmail.com> wrote:
> On Fri, Jun 17, 2011 at 11:54 AM, Paul Hartman <paul.hartman@gmail.com> wrote:
>> On Fri, Jun 17, 2011 at 1:29 PM, Mark Knecht <markknecht@gmail.com> wrote:
>>>   We ran memtest86 for an hour. Completed a couple of passes with no
>>> errors. Will run more later but no obvious memory problems seen.
>>>
>>>   I installed 2.6.39-gentoo-r1. No change from 2.6.38-gentoo-r6.
>>> Stops at the same place.
>>>
>>>   I tried 2.6.39-gentoo-r1 with no kernel options, and with all
>>> combinations of nousb and acpi=off. All 4 attempts quit at the same
>>> place.
>>
>> Check out this forum post, this person's bootup seems to stop in the
>> same place as yours. He was able to fix it by booting off a liveCD and
>> manually creating device nodes. Maybe it's nothing, but probably worth
>> looking at just in case it might help.
>>
>> https://www.linuxquestions.org/questions/gentoo-87/booting-stops-after-kernel-starts-883031/
>>
>
> Argh!! I remember a post like that on the Gentoo list. I'll check if
> out and give it a try.
>
> Thnaks,
> Mark
>
Thanks again Paul. That was exactly the solution I needed.

I remember this thread, or one like it, on the Gentoo-user list, but I
didn't follow the thread. I just remember that the Gentoo tarball was
not created correctly and these devices were left out. Adding them in
solved all the problem. Machine boots, we've updated @world and are
building KDE as I write this.

Thanks very much for your help.

Cheers,
Mark
