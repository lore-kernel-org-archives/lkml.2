Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755559Ab0EQUjM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 May 2010 16:39:12 -0400
Received: from eu1sys200aog110.obsmtp.com ([207.126.144.129]:47825 "EHLO
	eu1sys200aog110.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754843Ab0EQUjL convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 May 2010 16:39:11 -0400
From: Linus WALLEIJ <linus.walleij@stericsson.com>
To: Sundar R IYER <sundar.iyer@stericsson.com>,
       Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Deepak Sikri <deepak.sikri79@gmail.com>,
       Viresh KUMAR <viresh.kumar@st.com>,
       Rajeev KUMAR <rajeev-dlh.kumar@st.com>,
       Armando VISCONTI <armando.visconti@st.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Vipin KUMAR <vipin.kumar@st.com>, Shiraz HASHIM <shiraz.hashim@st.com>,
       "linux-pm@lists.linux-foundation.org" 
	<linux-pm@lists.linux-foundation.org>,
       STEricsson_nomadik_linux <STEricsson_nomadik_linux@list.st.com>
Date: Mon, 17 May 2010 22:38:53 +0200
Subject: RE: [linux-pm] Power Domain Framework
Thread-Topic: [linux-pm] Power Domain Framework
Thread-Index: Acr16MHp20jObKm+Sl6JhmVxIBRL4QAF/rOw
Message-ID: <CEE6BB42CAD6E947908279175AF8470A025A726240@EXDCVYMBSTM006.EQ1STM.local>
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
In-Reply-To: <1274118332.17303.17.camel@bnru01>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="Windows-1252"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[Sundar]

> This is one of the most important aspect for such a change in the
> regulator framework: bringing in the domain aspect can encourage all
> newer (possibly older) architectures to come under a generic umbrella.

I have the same view, and I've been enouraging Sundar to bring this
discussion with the community in order to avoid code duplication.

Of course we can start inventing our own power-domain machine
like everyone else, but before we do that, let's atleast try to
do something generic, so bear with us...

Yours,
Linus Walleij
