Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753771Ab2FLRPO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Jun 2012 13:15:14 -0400
Received: from g5t0007.atlanta.hp.com ([15.192.0.44]:45948 "EHLO
	g5t0007.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753445Ab2FLRPK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Jun 2012 13:15:10 -0400
Message-ID: <1339521308.2628.13.camel@lorien2>
Subject: Re: [PATCH] leds: use led_brightness_set in led_trigger_event
From: Shuah Khan <shuahkhan@gmail.com>
Reply-To: shuahkhan@gmail.com
To: Bryan Wu <bryan.wu@canonical.com>
Cc: shuahkhan@gmail.com, Fabio Baltieri <fabio.baltieri@gmail.com>,
        linux-leds@vger.kernel.org, linux-kernel@vger.kernel.org,
        Richard Purdie <rpurdie@rpsys.net>
Date: Tue, 12 Jun 2012 11:15:08 -0600
In-Reply-To: <CAK5ve-+D7vPO1U4gZDHRBmafJtF5T_EYBPCSAT2YOXjbc_u4zQ@mail.gmail.com>
References: <1339448260-1733-1-git-send-email-fabio.baltieri@gmail.com>
	 <1339450705.23857.16.camel@lorien2> <20120612071649.GA1306@gmail.com>
	 <CAK5ve-+D7vPO1U4gZDHRBmafJtF5T_EYBPCSAT2YOXjbc_u4zQ@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> 
> Thanks for catching this. It's a good idea we sort out those confusing name.
> Probably __led_set_bringness() is more conventional than _led_set_brightness().
> 
> And might also need to revisit other function names.
> 
> >> I can volunteer to make this change if we agree that this will be a good
> >> one to clear this naming confusion.
> >
> 
> OK, good Shuah, please go ahead and submit patches and I will hold
> this patch for a while and wait for the final fixing.
> 

Thanks. __led_set_brightness() sounds good. Will base patches off of
linux-leds devel unless that is not the right one.

-- Shuah


