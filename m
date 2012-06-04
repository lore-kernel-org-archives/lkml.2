Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757075Ab2FDJ6k (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jun 2012 05:58:40 -0400
Received: from eu1sys200aog113.obsmtp.com ([207.126.144.135]:35573 "EHLO
	eu1sys200aog113.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756982Ab2FDJ6h convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jun 2012 05:58:37 -0400
From: Sjur BRENDELAND <sjur.brandeland@stericsson.com>
To: Ohad Ben-Cohen <ohad@wizery.com>
Cc: Loic PALLARDY <loic.pallardy@stericsson.com>,
        Ludovic BARRE <ludovic.barre@stericsson.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Arnd Bergmann <arnd@arndb.de>,
        Linus Walleij <linus.walleij@linaro.org>,
        =?iso-8859-1?Q?Sjur_Br=E6ndeland?= <sjurbren@gmail.com>
Date: Mon, 4 Jun 2012 11:58:23 +0200
Subject: RE: [RFC 2/6] remoteproc: Pass struct fw to load_segments and
 find_rsc_table.
Thread-Topic: [RFC 2/6] remoteproc: Pass struct fw to load_segments and
 find_rsc_table.
Thread-Index: Ac1BjwsnM3AV1gVgQROdexl1lONYUgApuWqg
Message-ID: <81C3A93C17462B4BBD7E272753C10579232F4FBCFD@EXDCVYMBSTM005.EQ1STM.local>
References: <1337693217-15466-1-git-send-email-sjur.brandeland@stericsson.com>
 <1337693217-15466-3-git-send-email-sjur.brandeland@stericsson.com>
 <CAK=WgbafpAC+DZ71Oon_PyiWGAryAxzZvttpeiFY+A_agYcMFw@mail.gmail.com>
 <CAK=WgbZXHvTQmQZ3Y9ZBLREmsfZx4Bk8Y-H42_1c_j3ZFSqgPQ@mail.gmail.com>
In-Reply-To: <CAK=WgbZXHvTQmQZ3Y9ZBLREmsfZx4Bk8Y-H42_1c_j3ZFSqgPQ@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> >> +       rproc->bootaddr = ehdr->e_entry;
> 
> We might want to dedicate this (humble) hunk its own handler, because
> I'm not sure it fits very well into rproc_find_rsc_table().

Sure, I can do this, but this whole thing is a bit obscure and I
didn't quite know what to do with it.

This value is not used anywhere in the upstream code. Couldn't we
just delete this, and you can add it when you upstream the code
where this is used?

Regards,
Sjur
