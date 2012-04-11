Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754711Ab2DKJc0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Apr 2012 05:32:26 -0400
Received: from smtprelay05.ispgateway.de ([80.67.31.94]:37435 "EHLO
	smtprelay05.ispgateway.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753882Ab2DKJcZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Apr 2012 05:32:25 -0400
Message-ID: <4F854FA0.2000809@ladisch.de>
Date: Wed, 11 Apr 2012 11:32:16 +0200
From: Clemens Ladisch <clemens@ladisch.de>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.15) Gecko/20110323 Thunderbird/3.1.9
MIME-Version: 1.0
To: =?UTF-8?B?VG9yYWxmIEbDtnJzdGVy?= <toralf.foerster@gmx.de>
CC: Jiri Slaby <jslaby@suse.cz>, linux-kernel@vger.kernel.org
Subject: Re: /proc/interrupts has non-printable chars in kernel 3.3.1
References: <201204101934.34046.toralf.foerster@gmx.de> <4F8479CD.5030907@suse.cz> <201204102023.07775.toralf.foerster@gmx.de>
In-Reply-To: <201204102023.07775.toralf.foerster@gmx.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Df-Sender: bGludXgta2VybmVsQGNsLmRvbWFpbmZhY3Rvcnkta3VuZGUuZGU=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Toralf Förster wrote:
> Jiri Slaby wrote at 20:19:57
>> On 04/10/2012 07:34 PM, Toralf Förster wrote:
>>>  47:     289270     468524   PCI-MSI-edge      @��
>>>  48:        297        413   PCI-MSI-edge      snd_hda_intel
>>
>> It would be great if you could dig out of dmesg, who is bound to the
>> interrupt.
>
> snd_hda_intel 0000:00:1b.0: irq 47 for MSI/MSI-X

Two HDA controllers are typically for the on-board codec and for the
GPU's HDMI outputs.

snd-hda-intel uses KBUILD_MODNAME for this string, so in theory, it
should not be possible for garbage to appear if the same string for
irq 48 is OK.

Which device is 0:1b.0 (see lspci)?  And does the high number of
interrupts indicate that you did play sounds through it?


Regards,
Clemens
