Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754933Ab0LNWIn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Dec 2010 17:08:43 -0500
Received: from mail-bw0-f45.google.com ([209.85.214.45]:62125 "EHLO
	mail-bw0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752146Ab0LNWIm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Dec 2010 17:08:42 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:x-enigmail-version:content-type
         :content-transfer-encoding;
        b=dV0RxLcLuP8AiGz9wezaeDzOcK+nq2c2mVJqY6g1KyrTLLy5WugkZ9m/slEWVNlfmT
         gsdIPzIQKsXsrExc3q1musG9x84ZesgPWOqHZUIBFDopHH8C3aQ/rjbRKUVozd5WSL5E
         MZ7fBHepgAlbhwLw503hTAycTOQ8++qoNmU4c=
Message-ID: <4D07EAE5.6050803@gmail.com>
Date: Tue, 14 Dec 2010 23:08:37 +0100
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; cs-CZ; rv:1.9.2.13) Gecko/20101206 SUSE/3.1.7 Thunderbird/3.1.7
MIME-Version: 1.0
To: "Rafael J. Wysocki" <rjw@suse.com>
CC: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
        Linux-pm mailing list <linux-pm@lists.linux-foundation.org>
Subject: Re: Resume hangs [was: mmotm 2010-12-02-16-34 uploaded]
References: <201012030107.oB317ZSW019223@imap1.linux-foundation.org> <201012051408.27730.rjw@suse.com> <4D05EFB2.3050703@gmail.com> <201012132210.51325.rjw@suse.com>
In-Reply-To: <201012132210.51325.rjw@suse.com>
X-Enigmail-Version: 1.1.2
Content-Type: text/plain; charset=ISO-8859-2
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/13/2010 10:10 PM, Rafael J. Wysocki wrote:
> On Monday, December 13, 2010, Jiri Slaby wrote:
>> On 12/05/2010 02:08 PM, Rafael J. Wysocki wrote:
>>> On Sunday, December 05, 2010, Jiri Slaby wrote:
>>>> On 12/03/2010 01:34 AM, akpm@linux-foundation.org wrote:
>>>>> The mm-of-the-moment snapshot 2010-12-02-16-34 has been uploaded to
>>>>
>>>> Hi, this kernel regresses with respect to resume. It doesn't wake up,
>>>> the screen is black with blinking cursor at position [1, 1].
>>>> 2010-11-23-16-12 seemed to be OK. In this one it is 100% reproducible so
>>>> far.
>>>>
>>>> I'm using pm-suspend, any ideas what to test before I start to find the
>>>> reason on my own?
>>>
>>> Please try the pm_test tests for core, processors and devices, eg.:
>>
>> Hmm, I haven't seen the issues since then. So it had to be some kind of
>> coincidence -- I see the issue occasionally for some time already. Now
>> it triggered twice in a row after I updated the kernel.
> 
> Hmm.  What hardware is that?

What exactly do you want to know about it? It's some specific intel
desktop machine, 3 years old, 2 intel cores, 6G of mem, 2 sata disks in
raid, dvb-t usb receiver (af9015), usb keyboard and mouse.

regards,
-- 
js
