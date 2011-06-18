Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755404Ab1FRLLq (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Jun 2011 07:11:46 -0400
Received: from alice.et.bocholt.fh-gelsenkirchen.de ([193.175.197.63]:34229
	"EHLO alice.et.bocholt.fh-gelsenkirchen.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754786Ab1FRLLo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Jun 2011 07:11:44 -0400
X-DKIM: Sendmail DKIM Filter v2.8.3 alice.et.bocholt.fh-gelsenkirchen.de p5IBBOj2015988
From: Dirk Gouders <gouders@et.bocholt.fh-gelsenkirchen.de>
To: Jesse Barnes <jbarnes@virtuousgeek.org>
Cc: linux-kernel@vger.kernel.org, Chris Wilson <chris@chris-wilson.co.uk>
Subject: Re: [2.6.39] drm/i915: blank screen on Lenovo Ideapad U160
In-Reply-To: <20110616114146.4662ea2f@jbarnes-desktop> (Jesse Barnes's message
	of "Thu, 16 Jun 2011 11:41:46 -0700")
References: <gi1uzevjl4.fsf@mx10.gouders.net>
	<alpine.DEB.2.00.1105311406210.5012@localhost6.localdomain6>
	<gitycau362.fsf@mx10.gouders.net> <giei3eoeic.fsf@mx10.gouders.net>
	<gi1uyx8m2f.fsf_-_@mx10.gouders.net>
	<20110615115903.685acba0@jbarnes-desktop>
	<giips6lr5a.fsf@mx10.gouders.net>
	<20110615144132.074167f3@jbarnes-desktop>
	<giei2ulpl1.fsf@mx10.gouders.net>
	<20110615150737.79cd5de7@jbarnes-desktop>
	<gi4o3q2plu.fsf@karga.hank.lab> <gizkli0zew.fsf@karga.hank.lab>
	<20110616094030.15714852@jbarnes-desktop>
	<gisjr9ll0j.fsf@mx10.gouders.net>
	<20110616114146.4662ea2f@jbarnes-desktop>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.3 (gnu/linux)
Date: Sat, 18 Jun 2011 13:11:23 +0200
Message-ID: <gik4cjl7hg.fsf@mx10.gouders.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-Greylist: Sender succeeded STARTTLS authentication, not delayed by milter-greylist-4.2.3 (alice.et.bocholt.fh-gelsenkirchen.de [192.168.0.63]); Sat, 18 Jun 2011 13:11:25 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jesse Barnes <jbarnes@virtuousgeek.org> writes:

>> > Does your machine also work if you set the lvds_use_ssc param to 0?
>> 
>> Yes, that works!
>> I undid all modifications, compiled the i915 driver as a module (I am
>> not sure if that is necessary) und used i915.lvds_use_ssc=0 as a
>> further bootparameter, I will attach the dmesg output.
>> 
>> Would you say "This problem was just a case of wrong parameter usage",
>> then?
>
> No, we should be parsing the VBT differently in your case it appears.
> But the simple change above will break other platforms, so it's
> possible we're missing a VBT format change and need to parse it
> differently depending on the version.

OK, thanks a lot for spending your time to help me to find this
comfortable workaround.

Please let me know if I can help with further testing.

Dirk
