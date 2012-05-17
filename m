Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761618Ab2EQKv1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 May 2012 06:51:27 -0400
Received: from mail-gg0-f174.google.com ([209.85.161.174]:52816 "EHLO
	mail-gg0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751712Ab2EQKvZ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 May 2012 06:51:25 -0400
MIME-Version: 1.0
In-Reply-To: <CAMjpGUf-AQHigrpBhxmOGJZgjfqfCWvRa29wURpGkVuj58suPg@mail.gmail.com>
References: <1337152826-9850-1-git-send-email-sonic.zhang@analog.com>
	<1337152826-9850-3-git-send-email-sonic.zhang@analog.com>
	<CAM=Q2csTziLb0niCTj6oW9G=BPa2VWN58rW2jF-A1VJKXwNfCQ@mail.gmail.com>
	<CAMjpGUf-AQHigrpBhxmOGJZgjfqfCWvRa29wURpGkVuj58suPg@mail.gmail.com>
Date: Thu, 17 May 2012 16:21:24 +0530
Message-ID: <CAM=Q2cujxAGes0c4Ls6L_fUENvJE=Vf10YXOvng3zku84eC6ng@mail.gmail.com>
Subject: Re: [PATCH 3/8] i2c: i2c-bfin-twi: Break dead waiting loop if i2c
 device misbehaves.
From: Shubhrajyoti Datta <omaplinuxkernel@gmail.com>
To: Mike Frysinger <vapier.adi@gmail.com>
Cc: sonic.zhang@analog.com, Ben Dooks <ben-linux@fluff.org>,
        Wolfram Sang <w.sang@pengutronix.de>, linux-i2c@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>,
        uclinux-dist-devel@blackfin.uclinux.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 17, 2012 at 10:53 AM, Mike Frysinger <vapier.adi@gmail.com> wrote:
> On Thu, May 17, 2012 at 1:20 AM, Shubhrajyoti Datta
> <omaplinuxkernel@gmail.com> wrote:
>> On Wed, May 16, 2012 at 12:50 PM,  <sonic.zhang@analog.com> wrote:
>>> From: Sonic Zhang <sonic.zhang@analog.com>
>>>
>>> Some fault i2c device may hold the sda/scl line and cause i2c driver
>>> wait in the BUS busy loop. This patch breaks this potential dead
>>> loop.
>>
>> How about using a non-busy loop while you are at it.
>
> the timings here are fairly small ...
OK no issues.
Anyways was just a suggestion.:-)

> -mike
