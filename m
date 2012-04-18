Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753327Ab2DROQZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Apr 2012 10:16:25 -0400
Received: from mail-gy0-f174.google.com ([209.85.160.174]:54104 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751064Ab2DROQX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Apr 2012 10:16:23 -0400
MIME-Version: 1.0
In-Reply-To: <4F83359B.90103@lwfinger.net>
References: <CAPM=9tz-2bXahnfDK0-anxyZcqFUPOSEewJxh2+2U51xypmw-w@mail.gmail.com>
	<CAPM=9tzqwZpWP9Ea-UVWYFcoVY-fa+jCf5FOShiMTrY4roN-og@mail.gmail.com>
	<4F83359B.90103@lwfinger.net>
Date: Wed, 18 Apr 2012 15:16:23 +0100
Message-ID: <CAPM=9txG+jzKUtnAfJ4dHUBY7fted0vs9WcteZ6aB+yWNdzLYw@mail.gmail.com>
Subject: Re: oops on rmmod of rtl8192ce
From: Dave Airlie <airlied@gmail.com>
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Linux Wireless List <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 9, 2012 at 8:16 PM, Larry Finger <Larry.Finger@lwfinger.net> wrote:
> On 04/09/2012 10:02 AM, Dave Airlie wrote:
>>
>> ping any ideas on this oops on unload?
>
>
> Sorry about the delay.
>
> The oops looks like interrupts are not being disabled soon enough. Does the
> following patch help?

Seems to help here alright, I did a few load/unload cycles this
morning on that laptop,

I'll keep testing it for the situations I need it for, i.e. resume
with wireless fail, which I haven't hit yet.

Dave.
