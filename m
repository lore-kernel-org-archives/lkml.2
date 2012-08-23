Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758325Ab2HWKXr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Aug 2012 06:23:47 -0400
Received: from mail-ob0-f174.google.com ([209.85.214.174]:36745 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753813Ab2HWKXm convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Aug 2012 06:23:42 -0400
MIME-Version: 1.0
In-Reply-To: <331ABD5ECB02734CA317220B2BBEABC13EA1EA53@DBDE01.ent.ti.com>
References: <1345617039-27469-1-git-send-email-anilkumar@ti.com>
 <201208220748.39106.arnd@arndb.de> <CAK-9PRBy0PCQ4XAVZzQpWv5rnT8A9f6F=qxT=pJEaioN7RN_5w@mail.gmail.com>
 <331ABD5ECB02734CA317220B2BBEABC13EA1B975@DBDE01.ent.ti.com>
 <CAK-9PRBDpxtrxZWL_x9Uz--GMWDN5anyB_fuKtLrvZcLoRR+FQ@mail.gmail.com>
 <331ABD5ECB02734CA317220B2BBEABC13EA1BDA9@DBDE01.ent.ti.com>
 <CAK-9PRD6FH=5g0SrVcw+81Witpo8zRfvnsmGaePaA4swjHWkSw@mail.gmail.com> <331ABD5ECB02734CA317220B2BBEABC13EA1EA53@DBDE01.ent.ti.com>
From: Chinmay V S <cvs268@gmail.com>
Date: Thu, 23 Aug 2012 15:53:10 +0530
Message-ID: <CAK-9PRCe3Q0Tjn1qNdzkVcrPmUm_BPQowDgKE4+wVu5T-SVTZQ@mail.gmail.com>
Subject: Re: [PATCH v2] lis3lv02d: Add STMicroelectronics lis331dlh digital accelerometer
To: "AnilKumar, Chimata" <anilkumar@ti.com>
Cc: "carmine.iascone@st.com" <carmine.iascone@st.com>,
        Arnd Bergmann <arnd@arndb.de>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "eric.piel@tremplin-utc.net" <eric.piel@tremplin-utc.net>,
        "jic23@cam.ac.uk" <jic23@cam.ac.uk>, "greg@kroah.com" <greg@kroah.com>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "broonie@opensource.wolfsonmicro.com" 
	<broonie@opensource.wolfsonmicro.com>,
        "dmitry.torokhov@gmail.com" <dmitry.torokhov@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Note from datasheet, "1LSb=4g/4096 at 12bit representation,
> ±2g Full-scale"

Precisely my point. All the datasheet says is :
1. It is +/-2G mode --> so Numerator is 4G.
2. We are using 12bits --> so Denominator is 2^12 = 4096.

There is no clear reason/justification as to why 12bits was chosen in
the first place. At this point unless someone from the
design/original-driver team actually confirms why the 12bit
representation was chosen, it is all conjecture on our part.

If you have the actual LIS331DLH hardware, can you verify if the lower
4bits do actually contain any data (or are they always zero). This
will help us decide whether to use them(16bit mode) or discard
them(12bit mode)?...

regards
ChinmayVS
