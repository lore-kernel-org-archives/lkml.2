Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755294Ab2GBPPn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jul 2012 11:15:43 -0400
Received: from eu1sys200aog111.obsmtp.com ([207.126.144.131]:57330 "EHLO
	eu1sys200aog111.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754082Ab2GBPPl convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jul 2012 11:15:41 -0400
From: Sjur BRENDELAND <sjur.brandeland@stericsson.com>
To: Ohad Ben-Cohen <ohad@wizery.com>, Stephen Boyd <sboyd@codeaurora.org>,
        Ludovic BARRE <ludovic.barre@stericsson.com>,
        Loic PALLARDY <loic.pallardy@stericsson.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Date: Mon, 2 Jul 2012 17:15:13 +0200
Subject: RE: [PATCH] remoteproc: block premature rproc booting
Thread-Topic: [PATCH] remoteproc: block premature rproc booting
Thread-Index: Ac1YTd5RFA78BLWYQ/eImmh9Dm35HgAF0WVg
Message-ID: <81C3A93C17462B4BBD7E272753C10579232F86BE4C@EXDCVYMBSTM005.EQ1STM.local>
References: <1337687472-23009-1-git-send-email-ohad@wizery.com>
 <4FBDFC4A.1060602@codeaurora.org>
 <CAK=WgbaP5qSso_Eu=Oup4eqLDcorZ-qf=mysMKiEvOS=m7yLmg@mail.gmail.com>
 <4FCD276A.80505@codeaurora.org>
 <CAK=WgbZo-8GXY9bVYGk0XZvqKrdaJZWeNkK1FhRWnH5doGYLjA@mail.gmail.com>
 <CAK=WgbZb367zq0QCUuwFU+KtBY0gw_+rsN9fm2YnM-heT+54jA@mail.gmail.com>
In-Reply-To: <CAK=WgbZb367zq0QCUuwFU+KtBY0gw_+rsN9fm2YnM-heT+54jA@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ohad,

> Sjur, Ludovic, Loic - what remoteproc API are you using today?
> 
> We'd like to get rid of the existing get/put interface and instead
> have everyone use the boot/shutdown one, just like rpmsg is doing
> today.
> 
> Are you ok with this change?

Yes, I'm ok with this,
but I cannot answer for Loic and Ludovic.

Regards,
Sjur
