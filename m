Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754259Ab1IGQw3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Sep 2011 12:52:29 -0400
Received: from mail-vx0-f174.google.com ([209.85.220.174]:61164 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754239Ab1IGQw0 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Sep 2011 12:52:26 -0400
MIME-Version: 1.0
In-Reply-To: <87aaag9vb8.fsf@begreifnix.stackframe.org>
References: <20110906173605.GA12577@hostway.ca>
	<87aaag9vb8.fsf@begreifnix.stackframe.org>
Date: Wed, 7 Sep 2011 12:52:25 -0400
Message-ID: <CA+5PVA5aEAgdKexWK_cg2zRJk5CFsg6rhp9Wx+80GjR7iaLkOA@mail.gmail.com>
Subject: Re: [3.1-rc4] Bus Fatal Error caused by "PCI: Set PCI-E Max Payload
 Size on fabric"
From: Josh Boyer <jwboyer@gmail.com>
To: Sven Schnelle <svens@stackframe.org>
Cc: Simon Kirby <sim@hostway.ca>, linux-kernel@vger.kernel.org,
        Jon Mason <mason@myri.com>, Jordan_Hargrave@dell.com,
        Jesse Barnes <jbarnes@virtuousgeek.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 7, 2011 at 12:22 PM, Sven Schnelle <svens@stackframe.org> wrote:
> Simon Kirby <sim@hostway.ca> writes:
>
>> Hello!
>>
>> Since trying 3.1-rc4 on a few Dell servers, all of them have booted up
>> with the amber error LED lit. "ipmitool sel list" shows:
>>
>>    1 | 09/06/2011 | 17:21:56 | Event Logging Disabled #0x72 | Log area reset/cleared | Asserted
>>    2 | 09/06/2011 | 17:25:38 | Critical Interrupt #0x18 | Bus Fatal Error | Asserted
>>    3 | 09/06/2011 | 17:25:38 | Unknown #0x1a |
>>    4 | 09/06/2011 | 17:25:38 | Unknown #0x1a |
>
> I'm seeing exact the same issue on a Dell 1950 Server. If anyone wants
> me to try additional debugging/patches, feel free to do
> so. Unfortunately i don't have the time/knowledge to debug that by myself.

I thought Jesse or Jon had a revert or partial fix queued up to send
to Linus, but I don't see anything in or post -rc5 yet.  That was
indicated in https://bugzilla.kernel.org/show_bug.cgi?id=42162

Jesse, Jon?

josh
