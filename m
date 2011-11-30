Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754433Ab1K3Gff (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Nov 2011 01:35:35 -0500
Received: from cantor2.suse.de ([195.135.220.15]:54686 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752049Ab1K3Gfb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Nov 2011 01:35:31 -0500
Date: Wed, 30 Nov 2011 15:34:05 +0900
From: Greg KH <gregkh@suse.de>
To: Morten CHRISTIANSEN <morten.christiansen@stericsson.com>
Cc: Linus Walleij <linus.walleij@linaro.org>, NeilBrown <neilb@suse.de>,
        Arnd Bergmann <arnd@arndb.de>,
        "myungjoo.ham@gmail.com" <myungjoo.ham@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Mike Lockwood <lockwood@android.com>,
        Arve =?iso-8859-1?B?SGr4bm5lduVn?= <arve@android.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Donggeun Kim <dg77.kim@samsung.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        Karl KOMIEROWSKI <karl.komierowski@stericsson.com>,
        Johan BJORNSTEDT <johan.bjornstedt@stericsson.com>,
        Daniel WILLERUD <daniel.willerud@stericsson.com>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Mian Yousaf KAUKAB <mian.yousaf.kaukab@stericsson.com>
Subject: Re: [RFC PATCH 0/3] introduce: Multistate Switch Class
Message-ID: <20111130063405.GA12052@suse.de>
References: <CAJ0PZbQBXF1f7F27bkkT_ezFFtFi7kRVbF5WZXn+ZenZj2hT7w@mail.gmail.com>
 <201111251402.28016.arnd@arndb.de>
 <CACRpkdZSQcdK5ndSThQPRFAvp=sNMNDgBo5S6+H=t+0AYtJhOw@mail.gmail.com>
 <20111127230836.GA29728@suse.de>
 <20111128123114.2601bd7c@notabene.brown>
 <20111128072713.GA17724@suse.de>
 <CACRpkdZ+Epa_Y2Kr3dy3-BM8qrcV3f3fWsJXUAbhMTqd268+hw@mail.gmail.com>
 <AFCDDB4A3EA003429EEF1E7B211FDBBA36EE80C928@EXDCVYMBSTM005.EQ1STM.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AFCDDB4A3EA003429EEF1E7B211FDBBA36EE80C928@EXDCVYMBSTM005.EQ1STM.local>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 28, 2011 at 04:09:47PM +0100, Morten CHRISTIANSEN wrote:
> Hello!
> 
> Linus is correct. However some more info might be useful? Feel free to drop off whenever in the more and more detailed explanations! This is a non-trivial issue that has had some effort spent on it already.
> 
> SUMMARY: Devices today charge at high current (1.5A) from a dedicated charger and 500mA max from a standard USB port, using the standard MaxPower parameter. It would have been great if devices could also charge at higher current from a host or hub port but that is not really practical due to HW issues, not SW issues. See below. A new USB Power Delivery spec is imminent that might be of interest?
> 
> SHORT VERSION OF PREVIOUS EFFORTS:
> Using HID for managing USB battery charging current from the host is indeed the correct approach. And a work effort in USB Device Working Group went all the way to "ready for publication" state - and then died (for a number of reasons) some years ago. (Due to IPR reasons I cannot forward the un-released version of the spec.)
> 
> I see no reason to revisit the HID approach since it will not get any device support. Even if it was the correct approach.

<snip>

thanks a lot for the information, it was very helpful.

greg k-h
