Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757009Ab2HVV3R (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Aug 2012 17:29:17 -0400
Received: from us-mx3.synaptics.com ([12.239.217.85]:44107 "EHLO
	us-mx3.synaptics.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754280Ab2HVV3N (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Aug 2012 17:29:13 -0400
X-PGP-Universal: processed;
	by securemail.synaptics.com on Wed, 22 Aug 2012 14:02:31 -0700
Message-ID: <50354F28.300@synaptics.com>
Date: Wed, 22 Aug 2012 14:29:12 -0700
From: Christopher Heiny <cheiny@synaptics.com>
Organization: Synaptics, Inc
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:14.0) Gecko/20120717 Thunderbird/14.0
MIME-Version: 1.0
To: Linus Walleij <linus.walleij@linaro.org>
CC: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Jean Delvare <khali@linux-fr.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Linux Input <linux-input@vger.kernel.org>,
        Allie Xiong <axiong@synaptics.com>,
        William Manson <wmanson@synaptics.com>,
        Peichen Chang <peichen.chang@synaptics.com>,
        Joerie de Gram <j.de.gram@gmail.com>,
        Wolfram Sang <w.sang@pengutronix.de>,
        Mathieu Poirier <mathieu.poirier@linaro.org>,
        Linus Walleij <linus.walleij@stericsson.com>,
        Naveen Kumar Gaddipati <naveen.gaddipati@stericsson.com>
Subject: Re: [RFC PATCH 00/11] input: Synaptics RMI4 Touchscreen Driver
References: <1345241877-16200-1-git-send-email-cheiny@synaptics.com> <CACRpkda6Aq_rmYjMx6fcYvPnEexZ47dhaiA3hsCozLyUT0Mikw@mail.gmail.com>
In-Reply-To: <CACRpkda6Aq_rmYjMx6fcYvPnEexZ47dhaiA3hsCozLyUT0Mikw@mail.gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/22/2012 05:50 AM, Linus Walleij wrote:
> On Sat, Aug 18, 2012 at 12:17 AM, Christopher Heiny
> <cheiny@synaptics.com> wrote:
>
>> This patch implements a driver supporting Synaptics ClearPad and other
>> touchscreen sensors that use the RMI4 protocol, as defined here:
>
> Nice!
>
>> This patch is against the v2.6.38 tag of Linus' kernel tree, commit
>> 521cb40b0c44418a4fd36dc633f575813d59a43d.  This will be our last patch against
>> such an old kernel version, future patches will be against 3.x kernels.
>
> Please use the head of the subsystem tree to do this work.
> In this case, use Dmitry's git.
>
> Currently I just cannot test this because we have no such old codebase
> around.

Yeah, we've been in a bind in that regard, mostly due to customer 
requirements to support Android Gingerbread.  At least we were able to 
drop Froyo support this time around. :-P

Going forward, though, we'll be tracking much newer kernels for our 
development, and hopefully getting patches out more frequently as well.


> But I will attempt to review the patch set!

Thanks!  We look forward to your input.

					Chris
