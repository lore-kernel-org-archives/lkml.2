Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755478Ab0EQVqu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 May 2010 17:46:50 -0400
Received: from eu1sys200aog110.obsmtp.com ([207.126.144.129]:60122 "EHLO
	eu1sys200aog110.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753271Ab0EQVqs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 May 2010 17:46:48 -0400
From: Linus WALLEIJ <linus.walleij@stericsson.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Sundar R IYER <sundar.iyer@stericsson.com>,
       Deepak Sikri <deepak.sikri79@gmail.com>,
       Viresh KUMAR <viresh.kumar@st.com>,
       Rajeev KUMAR <rajeev-dlh.kumar@st.com>,
       Armando VISCONTI <armando.visconti@st.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Vipin KUMAR <vipin.kumar@st.com>, Shiraz HASHIM <shiraz.hashim@st.com>,
       "linux-pm@lists.linux-foundation.org" 
	<linux-pm@lists.linux-foundation.org>,
       STEricsson_nomadik_linux <STEricsson_nomadik_linux@list.st.com>
Date: Mon, 17 May 2010 23:46:38 +0200
Subject: RE: [linux-pm] Power Domain Framework
Thread-Topic: [linux-pm] Power Domain Framework
Thread-Index: Acr2BnrEuI3u4ibORk+1kDgZ5+rCiwAA4RoQ
Message-ID: <CEE6BB42CAD6E947908279175AF8470A025A72624A@EXDCVYMBSTM006.EQ1STM.local>
References: <AANLkTinZU1D1rMOBQDi47tRhXrOXwduQIdni7bCXdce0@mail.gmail.com>
	 <20100510140527.GG5199@sirena.org.uk>
	 <AANLkTikyqnKDNz7FIUvLDAvBReHskHvRCrEz2qBBqseH@mail.gmail.com>
	 <20100517031613.GA3130@opensource.wolfsonmicro.com>
	 <AANLkTimDdBCnRFMDiUkuNKanOzuPNwCpfRv9Gsi03Lsy@mail.gmail.com>
	 <AANLkTinZRhUpFTOOUCdH5dEl3QaXn10USL_hPPQX8cie@mail.gmail.com>
	 <20100517143319.GC5257@opensource.wolfsonmicro.com>
	 <AANLkTiniwUDg8rQzwgm_X7EbkQJ9tHzBfVtaJRiNE9az@mail.gmail.com>
	 <1274114107.20589.64.camel@bnru01>	 (sfid-20100517_173524_963855_B42F2966)
 <1274115886.2698.22.camel@finisterre.wolfsonmicro.main>
	 <1274118332.17303.17.camel@bnru01>
	 <CEE6BB42CAD6E947908279175AF8470A025A726240@EXDCVYMBSTM006.EQ1STM.local>
	 (sfid-20100517_213915_202336_5BFAA478)
 <1274131108.2698.161.camel@finisterre.wolfsonmicro.main>
In-Reply-To: <1274131108.2698.161.camel@finisterre.wolfsonmicro.main>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by alpha.home.local id o4HLkwaS023727

[Mark]

> I do agree that separating out the common bits of power
> domain implementation would be good, my concerns here are around the
> level of integration with the regulator API.

The plenty talk about power domains in
Documentation/power/regulators/overview.txt
was what got us started in this regulator direction from the
beginning.

Anyhow: it will certainly be closely related even if we come
up with some different API for power domains so we're in the
right forum.

Linus
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
