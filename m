Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754147Ab1HOOpL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Aug 2011 10:45:11 -0400
Received: from mail-ew0-f46.google.com ([209.85.215.46]:64777 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753600Ab1HOOpJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Aug 2011 10:45:09 -0400
MIME-Version: 1.0
In-Reply-To: <alpine.OSX.2.00.1108151724491.211@ibook.local>
References: <1313384834-24433-1-git-send-email-lacombar@gmail.com>
	<1313384834-24433-2-git-send-email-lacombar@gmail.com>
	<alpine.OSX.2.00.1108151724491.211@ibook.local>
Date: Mon, 15 Aug 2011 10:45:08 -0400
Message-ID: <CACqU3MXUp2hWaGNDmnBm2dO=27p4FBFNjRV8heA7p04Yf-nkwQ@mail.gmail.com>
Subject: Re: [PATCH 01/11] arch/m68k: do not use EXTRA_{A,C,LD}FLAGS
From: Arnaud Lacombe <lacombar@gmail.com>
To: Finn Thain <fthain@telegraphics.com.au>
Cc: linux-kernel@vger.kernel.org, Sam Ravnborg <sam@ravnborg.org>,
        linux-m68k@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Mon, Aug 15, 2011 at 3:26 AM, Finn Thain <fthain@telegraphics.com.au> wrote:
>
> On Mon, 15 Aug 2011, Arnaud Lacombe wrote:
>
>> -# EXTRA_CFLAGS += -DTRAP_DBG_INTERRUPT
>> -# EXTRA_AFLAGS += -DTRAP_DBG_INTERRUPT
>> +# ccflags-y += -DTRAP_DBG_INTERRUPT
>> +# ccflags-y += -DTRAP_DBG_INTERRUPT
>
> asflags-y?
>
yes, indeed. I'll resend later on.

 - Arnaud

> Finn
>
