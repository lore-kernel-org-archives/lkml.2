Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758202Ab1KVRDz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Nov 2011 12:03:55 -0500
Received: from ch1ehsobe005.messaging.microsoft.com ([216.32.181.185]:48824
	"EHLO ch1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754591Ab1KVRDy convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Nov 2011 12:03:54 -0500
X-SpamScore: -17
X-BigFish: VPS-17(zz936eK148cM1432N98dKzz1202hzz8275bhz2dh2a8h668h839h944h)
X-Forefront-Antispam-Report: CIP:137.71.25.57;KIP:(null);UIP:(null);IPV:NLI;H:nwd2mta2.analog.com;RD:nwd2mail11.analog.com;EFVD:NLI
X-FB-SS: 13,
From: "Hennerich, Michael" <Michael.Hennerich@analog.com>
To: Arnd Bergmann <arnd@arndb.de>
CC: "greg@kroah.com" <greg@kroah.com>,
        "device-drivers-devel@blackfin.uclinux.org" 
	<device-drivers-devel@blackfin.uclinux.org>,
        Drivers <Drivers@analog.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Tue, 22 Nov 2011 17:03:10 +0000
Subject: RE: [PATCH 2/2] misc: ad525x_dpot: Add support for SPI module
 device table matching
Thread-Topic: [PATCH 2/2] misc: ad525x_dpot: Add support for SPI module
 device table matching
Thread-Index: AcypMYMO77xSb5njTbiCcgQmpashXAABuobw
Message-ID: <544AC56F16B56944AEC3BD4E3D5917714872FF3A29@LIMKCMBX1.ad.analog.com>
References: <1321610711-12507-1-git-send-email-michael.hennerich@analog.com>
 <1321610711-12507-2-git-send-email-michael.hennerich@analog.com>
 <201111221611.19190.arnd@arndb.de>
In-Reply-To: <201111221611.19190.arnd@arndb.de>
Accept-Language: de-DE, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: de-DE, en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OriginatorOrg: analog.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Arnd Bergmann wrote on 2011-11-22:
> On Friday 18 November 2011, michael.hennerich@analog.com wrote:
>> From: Michael Hennerich <michael.hennerich@analog.com>
>>
>> Passing device name via platform data, is a leftover from times where
>> SPI module device table matching was not existent.
>>
>> * Add id_table and remove old mechanism.
>> (To my knowledge no intree boards affected)
>> * Miscellaneous other cleanup.
>
> The patch looks good to me, but please don't do "miscelaneous other
> cleanup" in the same patch. I think doing cleanups while you change a
> driver is a good idea, just do the extra step to split those out into a
> cleanup patch and describe what you do, just like you have split out the
> bug fix.
>
>       Arnd

Hi Arnd,

Thanks for reminding me.
Will do in future.

Greetings,
Michael

--
Analog Devices GmbH      Wilhelm-Wagenfeld-Str. 6      80807 Muenchen
Sitz der Gesellschaft: Muenchen; Registergericht: Muenchen HRB 40368;
Geschaeftsfuehrer:Dr.Carsten Suckrow, Thomas Wessel, William A. Martin, Margaret Seif


