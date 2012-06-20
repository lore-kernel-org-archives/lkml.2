Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754757Ab2FTHXr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jun 2012 03:23:47 -0400
Received: from na3sys009aog136.obsmtp.com ([74.125.149.85]:52262 "EHLO
	na3sys009aog136.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753951Ab2FTHXo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jun 2012 03:23:44 -0400
MIME-Version: 1.0
In-Reply-To: <4FE0AE7B.4040502@gmail.com>
References: <CACVXFVO-Wm1Qwporby1M=+yPz81AWHpZRBZSbr5tgT32b6sSEA@mail.gmail.com>
	<CANrkHUYd8Ww6De4MiZ8_oPfcnhvtsZXOySLRiWSBU4QUQ6beHw@mail.gmail.com>
	<CACVXFVP16UmHe-GGydrSMgGHwnkSvYhnY339=zr=BfCehvS8Kw@mail.gmail.com>
	<CANrkHUaxJGcv2bdUWTCB_oKct-iFCKCdb7OQPTUjS4MuKeCS2w@mail.gmail.com>
	<4FE0AE7B.4040502@gmail.com>
Date: Wed, 20 Jun 2012 12:53:41 +0530
Message-ID: <CANrkHUawrQfb+o+W7FrYACv6NocZn_MAym5A209peP8tW1nZRQ@mail.gmail.com>
Subject: Re: MMC: commit dba3c29 ruins mmc card data on beagle-xm revB
From: "T Krishnamoorthy, Balaji" <balajitk@ti.com>
To: Paolo Pisati <p.pisati@gmail.com>
Cc: Ming Lei <ming.lei@canonical.com>, linux-mmc@vger.kernel.org,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Chris Ball <cjb@laptop.org>, Venkatraman S <svenkatr@ti.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 19, 2012 at 10:23 PM, Paolo Pisati <p.pisati@gmail.com> wrote:
> On 06/13/2012 05:28 PM, T Krishnamoorthy, Balaji wrote:
>> On Mon, Jun 11, 2012 at 12:50 PM, Ming Lei <ming.lei@canonical.com> wrote:
>>>
>>> On Mon, Jun 11, 2012 at 2:21 PM, T Krishnamoorthy, Balaji
>>> <balajitk@ti.com> wrote:
>>>> Hi Ming Lei,
>>>> Can you let me know if you noticed any write/timeout errors ?
>>>
>>> Nothing error logs found during writing.
>> Hi,
>>
>> Couldn't reproduce the issue with BeagleXM rev C, Might be a combination
>> of rev and SD card. How often do you see mis-match in file content?
>
> i just want to say that i'm affected by this too, and i can reproduce it
> 100%.
>

Is it with SD or MMC card
Can you provide Beagle board rev info?

> do you want me to run that patch or you already have enough data?

Can you enable MMC debug and apply the debug patch I provided.
The debug patch did not print any AUTOCMD errors with Ming Lei setup.

> --
> bye,
> p.
