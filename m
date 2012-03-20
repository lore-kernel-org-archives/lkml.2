Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754365Ab2CTM6k (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Mar 2012 08:58:40 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:59639 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753359Ab2CTM6i convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Mar 2012 08:58:38 -0400
From: "Manjunathappa, Prakash" <prakash.pm@ti.com>
To: Samuel Ortiz <sameo@linux.intel.com>
CC: "davinci-linux-open-source@linux.davincidsp.com" 
	<davinci-linux-open-source@linux.davincidsp.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-mtd@lists.infradead.org" <linux-mtd@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Nori, Sekhar" <nsekhar@ti.com>,
        "linux@arm.linux.org.uk" <linux@arm.linux.org.uk>,
        "dwmw2@infradead.org" <dwmw2@infradead.org>,
        Arnd Bergmann <arnd@arndb.de>
Subject: RE: [PATCH v5 2/3] arm:davinci: move emif driver to mfd framework
Thread-Topic: [PATCH v5 2/3] arm:davinci: move emif driver to mfd framework
Thread-Index: AQHM8jX94hGGsvaFkE+bBaOmSVmhh5ZQdwIAgAFTzjCAAzAEgIAH0xCQgBAmEgCABfNwYA==
Date: Tue, 20 Mar 2012 12:57:55 +0000
Message-ID: <A73F36158E33644199EB82C5EC81C7BC3178627F@DBDE01.ent.ti.com>
References: <y> <1330005504-25321-3-git-send-email-prakash.pm@ti.com>
 <20120227142638.GN27687@sortiz-mobl>
 <A73F36158E33644199EB82C5EC81C7BC3176D103@DBDE01.ent.ti.com>
 <20120301112329.GI9008@sortiz-mobl>
 <A73F36158E33644199EB82C5EC81C7BC317702E9@DBDE01.ent.ti.com>
 <20120316172908.GG20524@sortiz-mobl>
In-Reply-To: <20120316172908.GG20524@sortiz-mobl>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [172.24.162.24]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Samuel,

On Fri, Mar 16, 2012 at 22:59:08, Samuel Ortiz wrote:
> Hi Prakash,
> 
> On Tue, Mar 06, 2012 at 01:12:25PM +0000, Manjunathappa, Prakash wrote:
> > Hi Samuel,
> > 
> > May be I did not do a good job giving complete information on this earlier.
> > So I have replied on top of my mail with below information (seems you missed it)
> > 
> I did get it, sorry for not being able to reply earlier.
> 
> 
> > Taking above points into consideration Arnd Bergmann suggested to move AEMIF driver to
> > MFD framework [1], relevant portion of his mail as follows,
> > 
> > " If you want it to provide endpoint devices that are handled by
> > distinct subsystems in Linux, I would make it an mfd multifunction
> > device and make the common... "
> You're missing that part of the quote:
> 
> "...code a driver that scans the connected memories in order to register
> its child devices for each of the subsystems."
> 

emif is not discoverable interface, does not support scanning for connected devices.

Could you please let me know if there is any other way to achieve this? I will be happy
to incorporate that and submit next version of the patch.

Thanks,
Prakash
