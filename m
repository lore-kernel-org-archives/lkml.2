Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752546Ab0H1BRf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Aug 2010 21:17:35 -0400
Received: from bosmailout06.eigbox.net ([66.96.186.6]:44320 "EHLO
	bosmailout06.eigbox.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751332Ab0H1BRd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Aug 2010 21:17:33 -0400
X-Greylist: delayed 1865 seconds by postgrey-1.27 at vger.kernel.org; Fri, 27 Aug 2010 21:17:33 EDT
X-EN-OrigOutIP: 10.20.18.1
X-EN-IMPSID: zcmP1e00201P9Sa01cmPBl
Message-ID: <4C785BE4.6010906@yahoo.es>
Date: Sat, 28 Aug 2010 08:44:20 +0800
From: Hein_Tibosch <hein_tibosch@yahoo.es>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; en-US; rv:1.9.2.8) Gecko/20100802 Thunderbird/3.1.2
MIME-Version: 1.0
To: Chris Ball <cjb@laptop.org>
CC: Pierre Ossman <pierre@ossman.eu>, Ben Nizette <bn@niasdigital.com>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        Adrian Hunter <adrian.hunter@nokia.com>, linux-mmc@vger.kernel.org,
        linux-kernel@vger.kernel.org, Matt Fleming <matt@console-pimps.org>,
        akpm@linux-foundation.org
Subject: Re: [PATCH v3] mmc: Make ID freq configurable
References: <20090702135849.21370282@hskinnemoen-d830> <1246537056.2980.60.camel@linux-51e8.site> <4B3E570C.2060602@yahoo.es> <63809451-ED1D-487A-AE63-F72B23D136D8@niasdigital.com> <4B3F019F.6010306@yahoo.es> <49985427-DCB9-40E1-815B-43C812B41DE3@niasdigital.com> <20100102130809.121b7e10@mjolnir.ossman.eu> <AD8E15FA-A476-4275-A750-5EB587A93CEC@niasdigital.com> <20100103003804.66021fe9@mjolnir.ossman.eu> <4B42648A.2040305@yahoo.es> <20100827204415.GU23079@void.printf.net>
In-Reply-To: <20100827204415.GU23079@void.printf.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-EN-UserInfo: 3946c951b80c12a8be5482963a0b1232:e0ae43bc192b431f8b69f09a37527cbc
X-EN-AuthUser: hein@htibosch.net
X-EN-OrigIP: 202.70.59.166
X-EN-OrigHost: unknown
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 On 28-8-2010 04:44, Chris Ball wrote:
> Hi,
>
> This looks like the best of the min_freq patches I've seen, and is
> implementing a suggestion of Pierre's.  Should we take it?
>
> - Chris.
>
> On Tue, Jan 05, 2010 at 05:58:34AM +0800, Hein_Tibosch wrote:
>> Below a patch which tries mmc-initialization using several frequencies
>> from an array 400, 300, 200 and 100.
>>
>>
>> Signed-off-by: Hein Tibosch <hein_tibosch@yahoo.es>
>> <cut>
Hi Chris,

Thanks. I can confirm that the above patch has been working properly for
7 months now, using various SD-cards.

Here it tries 3 frequencies, which takes 290 ms:

   000 mmc_rescan: trying 400000 Hz
       Waiting 1sec before mounting root device...
   061 mci: F now 400000 (actual 397727)
       usb 1-2: configuration #1 chosen from 1 choice
   126 mmc_rescan: trying 300000 Hz
       input: eGalax Inc. USB TouchController as /class/input/input1
   193 mci: F now 300000 (actual 299145)
   227 mmc_rescan: trying 200000 Hz
   255 mci: F now 200000 (actual 200000)
   290 mmc0: new SD card at address e624

In a meanwhile it is doing other things, so not much time is wasted.
But most importantly: it never failed to initialize a card.

Hein Tibosch
