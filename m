Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756218Ab0ERGBP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 May 2010 02:01:15 -0400
Received: from eu1sys200aog110.obsmtp.com ([207.126.144.129]:38892 "EHLO
	eu1sys200aog110.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755432Ab0ERGBO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 May 2010 02:01:14 -0400
Subject: RE: [linux-pm] Power Domain Framework
From: Sundar R Iyer <sundar.iyer@stericsson.com>
Reply-To: <sundar.iyer@stericsson.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Linus WALLEIJ <linus.walleij@stericsson.com>,
       Deepak Sikri <deepak.sikri79@gmail.com>,
       Viresh KUMAR <viresh.kumar@st.com>,
       Rajeev KUMAR <rajeev-dlh.kumar@st.com>,
       Armando VISCONTI <armando.visconti@st.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Vipin KUMAR <vipin.kumar@st.com>, Shiraz HASHIM <shiraz.hashim@st.com>,
       "linux-pm@lists.linux-foundation.org" 
	<linux-pm@lists.linux-foundation.org>,
       STEricsson_nomadik_linux <STEricsson_nomadik_linux@list.st.com>
In-Reply-To: <1274134636.2698.170.camel@finisterre.wolfsonmicro.main>
References: <AANLkTinZU1D1rMOBQDi47tRhXrOXwduQIdni7bCXdce0@mail.gmail.com>
	 <20100510140527.GG5199@sirena.org.uk>
	 <AANLkTikyqnKDNz7FIUvLDAvBReHskHvRCrEz2qBBqseH@mail.gmail.com>
	 <20100517031613.GA3130@opensource.wolfsonmicro.com>
	 <AANLkTimDdBCnRFMDiUkuNKanOzuPNwCpfRv9Gsi03Lsy@mail.gmail.com>
	 <AANLkTinZRhUpFTOOUCdH5dEl3QaXn10USL_hPPQX8cie@mail.gmail.com>
	 <20100517143319.GC5257@opensource.wolfsonmicro.com>
	 <AANLkTiniwUDg8rQzwgm_X7EbkQJ9tHzBfVtaJRiNE9az@mail.gmail.com>
	 <1274114107.20589.64.camel@bnru01>
	 (sfid-20100517_173524_963855_B42F2966) <1274115886.2698.22.camel@finisterre.wolfsonmicro.main>
	 <1274118332.17303.17.camel@bnru01>
	 <CEE6BB42CAD6E947908279175AF8470A025A726240@EXDCVYMBSTM006.EQ1STM.local>
	 (sfid-20100517_213915_202336_5BFAA478) <1274131108.2698.161.camel@finisterre.wolfsonmicro.main>
	 <CEE6BB42CAD6E947908279175AF8470A025A72624A@EXDCVYMBSTM006.EQ1STM.local>
	 (sfid-20100517_224652_794912_8E56D9D6)  <1274134636.2698.170.camel@finisterre.wolfsonmicro.main>
Content-Type: text/plain
Organization: STEricsson
Date: Tue, 18 May 2010 11:30:50 +0530
Message-ID: <1274162450.17303.35.camel@bnru01>
MIME-Version: 1.0
X-Mailer: Evolution 2.24.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

> Yeah, sure - obviously, the generic concept of power domains is
> something that does exist within the off-SoC hardware, but on-SoC the
> end implementation is a bit different.

Exactly. This is what I can see if we can bridge this "a bit different".

True, I am dumb to miss out some points, but I think with more inputs,
more thinking, we can definitely make it generic!

Thinking out loud ( excuse me if this is dumb), At the end of the day,
how I see this benefiting a lay driver developer is : use the regulator
API for the appropriate power sources - your SoC domain, your external
regulator domain..etc..etc and ensure a very efficient (probably) run
time PM for your device. All that the Platform guy will do is iterate 
a list of domains on the platform, provide hookups, ensure constraints 
etc and the job is done. Even if the same IP is used on a different SoC,
you still ensure efficient savings in your driver itself.

> As I said in reply to the patch I am concerned that this may be an
> oversimplification relative to what general hardware needs.
Ohh. for the patch set, as I said, its only a primitive implementation.
With your inputs, we can definitely make it more efficient!

Regards,
Sundar

