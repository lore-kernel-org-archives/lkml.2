Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758175Ab2AMNti (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jan 2012 08:49:38 -0500
Received: from eu1sys200aog115.obsmtp.com ([207.126.144.139]:59387 "EHLO
	eu1sys200aog115.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753052Ab2AMNth (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jan 2012 08:49:37 -0500
Message-ID: <4F10362D.3020507@stericsson.com>
Date: Fri, 13 Jan 2012 14:48:29 +0100
From: Linus Walleij <linus.walleij@stericsson.com>
Organization: ST-Ericsson SA
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.23) Gecko/20110921 Thunderbird/3.1.15
MIME-Version: 1.0
To: Shawn Guo <shawn.guo@linaro.org>
Cc: Dong Aisheng-B29396 <B29396@freescale.com>,
        Stephen Warren <swarren@nvidia.com>, Dong Aisheng <dongas86@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "s.hauer@pengutronix.de" <s.hauer@pengutronix.de>,
        "rob.herring@calxeda.com" <rob.herring@calxeda.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "kernel@pengutronix.de" <kernel@pengutronix.de>,
        "cjb@laptop.org" <cjb@laptop.org>,
        "devicetree-discuss@lists.ozlabs.org" 
	<devicetree-discuss@lists.ozlabs.org>,
        "Simon Glass (sjg@chromium.org)" <sjg@chromium.org>
Subject: Re: [RFC PATCH v3 2/5] pinctrl: add dt binding support for pinmux
 mappings
References: <CAA+hA=RBqpSmntS2h+6xMQuRvSRHenmDgrYSSzMXHtOCpU+HCQ@mail.gmail.com> <74CDBE0F657A3D45AFBB94109FB122FF17761F18F8@HQMAIL01.nvidia.com> <7FE21149F4667147B645348EC605788507F698@039-SN2MPN1-013.039d.mgd.msft.net> <74CDBE0F657A3D45AFBB94109FB122FF177EE39E6B@HQMAIL01.nvidia.com> <7FE21149F4667147B645348EC605788508AC65@039-SN2MPN1-013.039d.mgd.msft.net> <74CDBE0F657A3D45AFBB94109FB122FF177EE3A76A@HQMAIL01.nvidia.com> <7FE21149F4667147B645348EC605788508E7B0@039-SN2MPN1-013.039d.mgd.msft.net> <74CDBE0F657A3D45AFBB94109FB122FF17801D1DD6@HQMAIL01.nvidia.com> <20120113035506.GB12184@S2101-09.ap.freescale.net> <7FE21149F4667147B645348EC605788508FD9C@039-SN2MPN1-013.039d.mgd.msft.net> <20120113133552.GB17029@S2101-09.ap.freescale.net>
In-Reply-To: <20120113133552.GB17029@S2101-09.ap.freescale.net>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/13/2012 02:35 PM, Shawn Guo wrote:
> My guess is that Linus.W did not get any chance to take the dt case
> into account with his first design of pinctrl core.  But I guess he
> is open to any reasonable change to pinctrl core for dt adoption.
> Linus?

Any patches welcome.

However we cannot *require* DT for pinctrl to work, there
are archs that do not use DT and these must also be able
to use pinctrl. For example arch/blackfin have expressed
interest IIRC.

Then the question of whether to also support mixed configs
where some callers get data from DT and some from
platform data. I suspect that this is necessary for the
single kernel goal.

Yours,
Linus Walleij
