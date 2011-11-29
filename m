Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752796Ab1K2Huc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Nov 2011 02:50:32 -0500
Received: from mail-ee0-f46.google.com ([74.125.83.46]:42536 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751814Ab1K2Hua (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Nov 2011 02:50:30 -0500
MIME-Version: 1.0
In-Reply-To: <CAAJw_ZvyWoprc8yCwET_2O67gpnQy=5imAQG=PVWT8OhB_7rXA@mail.gmail.com>
References: <20111125122143.GA30404@gamma.logic.tuwien.ac.at>
	<CANUX_P1hFzSVPQzd6gq3tLY7hu+LX5suph6uHP+hq6+7rdAK1w@mail.gmail.com>
	<20111125123720.GA31564@gamma.logic.tuwien.ac.at>
	<CANUX_P2mGQX9H-f7OFusjUrv8ey56JNzFVEdKJkAejsg9zVNkQ@mail.gmail.com>
	<CANUX_P1aAz-4TpgSzQ2G=RkJOxXCAVQBja3GNsj_HpMNmqxeUw@mail.gmail.com>
	<1322387175.4044.16.camel@jlt3.sipsolutions.net>
	<CANUX_P3uoNOj3j-REvYCZP382cHfq+DpBRi7fnzFfMG_dyHtTQ@mail.gmail.com>
	<20111128035627.GH1422@gamma.logic.tuwien.ac.at>
	<CANUX_P2kYiFCP8uAhLZC_kVEjoyxabRBx3Pn+ndtFus=6hJN7Q@mail.gmail.com>
	<20111128042343.GA4619@gamma.logic.tuwien.ac.at>
	<20111128232525.GA12719@gamma.logic.tuwien.ac.at>
	<CANUX_P2b_ZYr4hHigA+tGa9uakcq3hQXnOiP5isQtfcYxCaxcw@mail.gmail.com>
	<CAAJw_ZvyWoprc8yCwET_2O67gpnQy=5imAQG=PVWT8OhB_7rXA@mail.gmail.com>
Date: Tue, 29 Nov 2011 09:50:29 +0200
Message-ID: <CANUX_P23E33VsBSyFY46T13AW9HYEO_jJAwO85Es1voP3xA1FQ@mail.gmail.com>
Subject: Re: iwlagn is getting very shaky
From: Emmanuel Grumbach <egrumbach@gmail.com>
To: Jeff Chua <jeff.chua.linux@gmail.com>
Cc: Norbert Preining <preining@logic.at>,
        "Guy, Wey-Yi" <wey-yi.w.guy@intel.com>,
        Pekka Enberg <penberg@cs.helsinki.fi>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Johannes Berg <johannes@sipsolutions.net>,
        Dave Jones <davej@redhat.com>, David Rientjes <rientjes@google.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>>
>>> Ok, here we go. First of all, it seems that the problem is solved
>>> inthe sense that the connection stays alive all the time and does not
>>> disappear. OTOH, I now get quite a lot of messages, that might point
>>> either to a broken AP here, or something else:
>>> =============================
>>> Anyway, the connection might stumble now and then a bit, but it does
>>> not break down, so I don't complain ;-)
>>>
>>> BIG THANKS to everyone!!!
>>>
>>
>> Thanks for you testing and patience.
>
> Does this have anything to do with another subject "MAC is in deep
> sleep!" ... Not trying to interrupt the discussion here, but my iwlagn
> is unstable at 3.2.0-rc3. I'm seeing a lot of "MAC is in deep sleep!"
>

Probably not.
