Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752903Ab1AUJmF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Jan 2011 04:42:05 -0500
Received: from nwd2mail11.analog.com ([137.71.25.57]:50629 "EHLO
	nwd2mail11.analog.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751876Ab1AUJmD convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Jan 2011 04:42:03 -0500
X-IronPort-AV: E=Sophos;i="4.60,357,1291611600"; 
   d="scan'208";a="27612473"
From: "Hennerich, Michael" <Michael.Hennerich@analog.com>
To: Andrew Morton <akpm@linux-foundation.org>,
        Richard Purdie <rpurdie@rpsys.net>
CC: Mike Frysinger <vapier@gentoo.org>,
        "device-drivers-devel@blackfin.uclinux.org" 
	<device-drivers-devel@blackfin.uclinux.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Fri, 21 Jan 2011 09:41:58 +0000
Subject: RE: [PATCH] backlight: new driver for the ADP8870 backlight devices
Thread-Topic: [PATCH] backlight: new driver for the ADP8870 backlight devices
Thread-Index: Acu5TdByeXs1cxJXTIW2qyZQlMnMkAAAGzbw
Message-ID: <544AC56F16B56944AEC3BD4E3D591771324C0A8C91@LIMKCMBX1.ad.analog.com>
References: <1294794049-17337-1-git-send-email-vapier@gentoo.org>
	<20110120164816.5afa0561.akpm@linux-foundation.org>
	<544AC56F16B56944AEC3BD4E3D591771324C0A8C6F@LIMKCMBX1.ad.analog.com>
 <20110121013013.076a0fed.akpm@linux-foundation.org>
In-Reply-To: <20110121013013.076a0fed.akpm@linux-foundation.org>
Accept-Language: de-DE, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: de-DE, en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton wrote on 2011-01-21:
> On Fri, 21 Jan 2011 09:25:50 +0000 "Hennerich, Michael"
> <Michael.Hennerich@analog.com> wrote:
>
>>> Is the sysfs API documented anywhere?
>>
>> Yes - http://wiki-analog.com/software/driver/linux/adp8870
>> I guess you are asking me to write something that goes into linux-
> 2.6.x/Documentation?
>
> That would be nice, please.  Documentation/ABI/, perhaps.
>
> In an ideal world, documentation wouldn't be necessary because all
> backlight drivers offer the same (or sufficiently similar) interfaces,
> so one generic document describes them all.  I don't know how close we
> are to that however.

This driver implements the ABI documented in
linux-2.6.x/Documentation/ABI/stable/sysfs-class-backlight
however it adds some additional ABI for ambient light sensor/zones.

http://wiki-analog.com/software/driver/linux/adp8870

Richard do you think my extension is suitable to be added there too?

Greetings,
Michael

--
Analog Devices GmbH      Wilhelm-Wagenfeld-Str. 6      80807 Muenchen
Sitz der Gesellschaft: Muenchen; Registergericht: Muenchen HRB 40368; Geschaeftsfuehrer:Dr.Carsten Suckrow, Thomas Wessel, William A. Martin, Margaret Seif


