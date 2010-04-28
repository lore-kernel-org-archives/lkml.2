Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753269Ab0D1Hyw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Apr 2010 03:54:52 -0400
Received: from mailout3.w1.samsung.com ([210.118.77.13]:17792 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750864Ab0D1Hyv convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Apr 2010 03:54:51 -0400
MIME-version: 1.0
Content-type: text/plain; charset=utf-8; format=flowed; delsp=yes
Date: Wed, 28 Apr 2010 09:55:07 +0200
From: =?utf-8?B?TWljaGHFgiBOYXphcmV3aWN6?= <m.nazarewicz@samsung.com>
Subject: Re: [PATCH RE-RESEND] Mass storage gadget: Handle eject request
In-reply-to: <u2tfb5cec441004270519s5aa901c0ib08a63f2be4f0af2@mail.gmail.com>
To: Chouteau Fabien <fabien.chouteau@gmail.com>, linux-usb@vger.kernel.org
Cc: Fabien Chouteau <fabien.chouteau@barco.com>,
       David Brownell <dbrownell@users.sourceforge.net>,
       Greg Kroah-Hartman <gregkh@suse.de>,
       Peter Korsgaard <jacmet@sunsite.dk>, linux-kernel@vger.kernel.org
Message-id: <op.vbu395at7p4s8u@pikus>
Organization: Samsung Electronics
Content-transfer-encoding: 8BIT
User-Agent: Opera Mail/10.10 (Linux)
References: <1272278094-25433-1-git-send-email-fabien.chouteau@gmail.com>
 <u2tfb5cec441004270519s5aa901c0ib08a63f2be4f0af2@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> On Mon, Apr 26, 2010 at 12:34 PM, <fabien.chouteau@gmail.com> wrote:
>> This patch adds handling of the "Start/Stop Unit" SCSI request
>> to simulate media ejection.

On Tue, 27 Apr 2010 14:19:42 +0200, Chouteau Fabien <fabien.chouteau@gmail.com> wrote:
> Any comments on the last version?

As far as I'm concerned, it looks fine.

-- 
Best regards,                                        _     _
| Humble Liege of Serenely Enlightened Majesty of  o' \,=./ `o
| Computer Science,  Michał "mina86" Nazarewicz       (o o)
+----[mina86*mina86.com]---[mina86*jabber.org]----ooO--(_)--Ooo--
