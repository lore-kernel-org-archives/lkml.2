Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754796Ab2D3AwL (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Apr 2012 20:52:11 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:42932 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752900Ab2D3AwK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Apr 2012 20:52:10 -0400
Message-ID: <4F9DE236.60002@lwfinger.net>
Date: Sun, 29 Apr 2012 19:52:06 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:11.0) Gecko/20120328 Thunderbird/11.0.1
MIME-Version: 1.0
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
CC: Andreas Schwab <schwab@linux-m68k.org>, Paul Mackerras <paulus@samba.org>,
        linuxppc-dev@lists.ozlabs.org, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] tty/serial/pmac_zilog: Fix "nobody cared" IRQ message
References: <4F9C830D.8040906@lwfinger.net> <1335745382.20866.18.camel@pasglop>
In-Reply-To: <1335745382.20866.18.camel@pasglop>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/29/2012 07:23 PM, Benjamin Herrenschmidt wrote:
> On Sat, 2012-04-28 at 18:53 -0500, Larry Finger wrote:
>
>>
>> Index: wireless-testing/drivers/tty/serial/pmac_zilog.c
>> ===================================================================
>> --- wireless-testing.orig/drivers/tty/serial/pmac_zilog.c	2012-04-28
>> 15:51:38.843723074 -0500
>> +++ wireless-testing/drivers/tty/serial/pmac_zilog.c	2012-04-28
>> 18:34:34.053900600 -0500
>
> Patch seems to be wrapped... I'll apply manually this time around but
> check your mailer settings :-)

Sorry about that. I don't usually send patches that way, and forgot to check for 
wrapping.

Larry


