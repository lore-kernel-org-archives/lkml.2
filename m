Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932290Ab1AKP4q (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Jan 2011 10:56:46 -0500
Received: from eu1sys200aog108.obsmtp.com ([207.126.144.125]:33885 "EHLO
	eu1sys200aog108.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932160Ab1AKP4o (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Jan 2011 10:56:44 -0500
From: Carmelo AMOROSO <carmelo.amoroso@st.com>
To: Mike Frysinger <vapier@gentoo.org>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Filippo ARCIDIACONO <filippo.arcidiacono@st.com>,
        "linux-sh@vger.kernel.org" <linux-sh@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "nicolas.pitre@linaro.org" <nicolas.pitre@linaro.org>,
        "nico@fluxnic.net" <nico@fluxnic.net>
Date: Tue, 11 Jan 2011 16:56:02 +0100
Subject: Re: [PATCH 1/2] stackprotector: add stack smashing protector
 generic implementation
Thread-Topic: [PATCH 1/2] stackprotector: add stack smashing protector
 generic implementation
Thread-Index: AcuxqA/hqFnFKR1+SOeJ3YfzE17dig==
Message-ID: <4D2C7D92.1090104@st.com>
References: <1293111851-7175-1-git-send-email-filippo.arcidiacono@st.com>
 <4D245D16.5010702@st.com>
 <AANLkTinZCDRVwwchcB85Wock8nBYK1eJrTWPbgJ-roGh@mail.gmail.com>
In-Reply-To: <AANLkTinZCDRVwwchcB85Wock8nBYK1eJrTWPbgJ-roGh@mail.gmail.com>
Accept-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-enigmail-version: 1.1.1
user-agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; en-US; rv:1.9.2.13)
 Gecko/20101207 Lightning/1.0b2 Thunderbird/3.1.7
acceptlanguage: en-US
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id p0BFut3R020945

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

On 1/11/2011 6:30 AM, Mike Frysinger wrote:
> what are you using to test this ? is there a simple strcpy or similar
> code you run as a kernel module that'll allow me to verify ?
> -mike
> 
Hi Mike,
yes, a simple kernel module with a init func that use strcpy or memcpy
to write over the boundaries of an local array variable is enough.
As you know, the array has to be larger than 8 bytes to match with the
gcc heuristic and generate the call to the guard.

Cheers,
Carmelo



-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (MingW32)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org/

iEYEARECAAYFAk0sfZIACgkQoRq/3BrK1s8kfwCeIjayIoaHapweG53icp1yoCN+
ypMAnA08chxTu49eP4QYTQU8UzO4PVpp
=ysi4
-----END PGP SIGNATURE-----
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
