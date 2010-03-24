Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752849Ab0CXXUl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Mar 2010 19:20:41 -0400
Received: from mail-iw0-f182.google.com ([209.85.223.182]:39459 "EHLO
	mail-iw0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752107Ab0CXXUk convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Mar 2010 19:20:40 -0400
MIME-Version: 1.0
In-Reply-To: <20100324230729.GA21359@n2100.arm.linux.org.uk>
References: <1269471898-26301-1-git-send-email-mroberto@cpti.cetuc.puc-rio.br> 
	<1269471898-26301-2-git-send-email-mroberto@cpti.cetuc.puc-rio.br> 
	<20100324230729.GA21359@n2100.arm.linux.org.uk>
From: Marcelo Jimenez <mroberto@cpti.cetuc.puc-rio.br>
Date: Wed, 24 Mar 2010 20:20:19 -0300
Message-ID: <cecb6d8f1003241620v55fb960ds14818bf3a03fa334@mail.gmail.com>
Subject: Re: [PATCH 2/2] ARM: pcmcia: fix checkpatch.pl issues in soc_common.c
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: Dominik Brodowski <linux@dominikbrodowski.net>,
       Wolfram Sang <w.sang@pengutronix.de>,
       linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
       linux-pcmcia@lists.infradead.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 24, 2010 at 20:07, Russell King - ARM Linux
<linux@arm.linux.org.uk> wrote:
> On Wed, Mar 24, 2010 at 08:04:58PM -0300, Marcelo Roberto Jimenez wrote:
>> -     debug(skt, 2, "mask: %s%s%s%s%s%sflags: %s%s%s%s%s%sVcc %d Vpp %d irq %d\n",
>> -                     (state->csc_mask==0)?"<NONE> ":"",
>> -                     (state->csc_mask&SS_DETECT)?"DETECT ":"",
>> -                     (state->csc_mask&SS_READY)?"READY ":"",
>> -                     (state->csc_mask&SS_BATDEAD)?"BATDEAD ":"",
>> -                     (state->csc_mask&SS_BATWARN)?"BATWARN ":"",
>> -                     (state->csc_mask&SS_STSCHG)?"STSCHG ":"",
>> -                     (state->flags==0)?"<NONE> ":"",
>> -                     (state->flags&SS_PWR_AUTO)?"PWR_AUTO ":"",
>> -                     (state->flags&SS_IOCARD)?"IOCARD ":"",
>> -                     (state->flags&SS_RESET)?"RESET ":"",
>> -                     (state->flags&SS_SPKR_ENA)?"SPKR_ENA ":"",
>> -                     (state->flags&SS_OUTPUT_ENA)?"OUTPUT_ENA ":"",
>> +     debug(skt, 2,   "mask: %s%s%s%s%s%s "
>> +                     "flags: %s%s%s%s%s%s Vcc %d Vpp %d irq %d\n",
>
> NAK.  Breaking kernel messages across multiple lines makes them impossible
> to grep for.  checkpatch.pl is wrong on this one.

I will redo it, no problem. But just for my information, in that
particular case, is it usefull to grep using format specifiers?
