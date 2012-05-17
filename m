Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754041Ab2EQFXf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 May 2012 01:23:35 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:57306 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752872Ab2EQFXd convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 May 2012 01:23:33 -0400
MIME-Version: 1.0
In-Reply-To: <CAM=Q2csTziLb0niCTj6oW9G=BPa2VWN58rW2jF-A1VJKXwNfCQ@mail.gmail.com>
References: <1337152826-9850-1-git-send-email-sonic.zhang@analog.com>
 <1337152826-9850-3-git-send-email-sonic.zhang@analog.com> <CAM=Q2csTziLb0niCTj6oW9G=BPa2VWN58rW2jF-A1VJKXwNfCQ@mail.gmail.com>
From: Mike Frysinger <vapier.adi@gmail.com>
Date: Thu, 17 May 2012 01:23:09 -0400
Message-ID: <CAMjpGUf-AQHigrpBhxmOGJZgjfqfCWvRa29wURpGkVuj58suPg@mail.gmail.com>
Subject: Re: [PATCH 3/8] i2c: i2c-bfin-twi: Break dead waiting loop if i2c
 device misbehaves.
To: Shubhrajyoti Datta <omaplinuxkernel@gmail.com>
Cc: sonic.zhang@analog.com, Ben Dooks <ben-linux@fluff.org>,
        Wolfram Sang <w.sang@pengutronix.de>, linux-i2c@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>,
        uclinux-dist-devel@blackfin.uclinux.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 17, 2012 at 1:20 AM, Shubhrajyoti Datta
<omaplinuxkernel@gmail.com> wrote:
> On Wed, May 16, 2012 at 12:50 PM,  <sonic.zhang@analog.com> wrote:
>> From: Sonic Zhang <sonic.zhang@analog.com>
>>
>> Some fault i2c device may hold the sda/scl line and cause i2c driver
>> wait in the BUS busy loop. This patch breaks this potential dead
>> loop.
>
> How about using a non-busy loop while you are at it.

the timings here are fairly small ...
-mike
