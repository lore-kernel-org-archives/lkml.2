Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754299Ab2EYKKg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 May 2012 06:10:36 -0400
Received: from mail-yx0-f174.google.com ([209.85.213.174]:43820 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751302Ab2EYKKR convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 May 2012 06:10:17 -0400
MIME-Version: 1.0
In-Reply-To: <DB904C5425BA6F4E8424B3B51A1414D170230E5ADF@NWD2CMBX1.ad.analog.com>
References: <1337152826-9850-1-git-send-email-sonic.zhang@analog.com>
	<1337152826-9850-8-git-send-email-sonic.zhang@analog.com>
	<CAM=Q2csSuQ3R9U=XKwj9F0xijTxx_ULperAiQYD_X3a5GKVjFg@mail.gmail.com>
	<DB904C5425BA6F4E8424B3B51A1414D170230E5ADF@NWD2CMBX1.ad.analog.com>
Date: Fri, 25 May 2012 15:40:16 +0530
Message-ID: <CAM=Q2cveBrYUiNYEbUgXyTnK2JhVD8UyhGgYJ=Zr86YnMMJ6Dg@mail.gmail.com>
Subject: Re: [PATCH 8/8] i2c: i2c-bfin-twi: Move blackfin TWI register access
 Macro to head file.
From: Shubhrajyoti Datta <omaplinuxkernel@gmail.com>
To: "Zhang, Sonic" <Sonic.Zhang@analog.com>
Cc: Ben Dooks <ben-linux@fluff.org>, Wolfram Sang <w.sang@pengutronix.de>,
        "linux-i2c@vger.kernel.org" <linux-i2c@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        "uclinux-dist-devel@blackfin.uclinux.org" 
	<uclinux-dist-devel@blackfin.uclinux.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi ,
On Fri, May 25, 2012 at 3:24 PM, Zhang, Sonic <Sonic.Zhang@analog.com> wrote:
>
>
>>-----Original Message-----
>>From: Shubhrajyoti Datta [mailto:omaplinuxkernel@gmail.com]
>>Sent: Friday, May 25, 2012 5:48 PM
>>To: Zhang, Sonic
>>Cc: Ben Dooks; Wolfram Sang; linux-i2c@vger.kernel.org; LKML; uclinux-dist-
>>devel@blackfin.uclinux.org
>>Subject: Re: [PATCH 8/8] i2c: i2c-bfin-twi: Move blackfin TWI register access
>>Macro to head file.
>>
>>Hi ,
>>Some minor comments/ doubts.
>>On Wed, May 16, 2012 at 12:50 PM,  <sonic.zhang@analog.com> wrote:
>>> From: Sonic Zhang <sonic.zhang@analog.com>
>>>
>>
>>A small description may be helpful.
>>Also the $SUBJECT says move the patch looks more like the remove.
>>Am I missing something.
>
> The subject says these definitions are moved to a head file by the other patch for Blackfin architecture.

Got it thanks.

You may want to add a dependency otherwise it might lead to a compilation break?


>
> Regards,
>
> Sonic
