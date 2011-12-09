Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753477Ab1LIMnc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Dec 2011 07:43:32 -0500
Received: from eu1sys200aog103.obsmtp.com ([207.126.144.115]:44535 "EHLO
	eu1sys200aog103.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752113Ab1LIMna convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Dec 2011 07:43:30 -0500
From: Sjur BRENDELAND <sjur.brandeland@stericsson.com>
To: Dan Carpenter <dan.carpenter@oracle.com>,
        Linus Walleij <linus.walleij@linaro.org>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kernel-janitors@vger.kernel.org" <kernel-janitors@vger.kernel.org>
Date: Fri, 9 Dec 2011 13:43:20 +0100
Subject: RE: [patch -next] xshm: calling unlock improperly in
 xshmchr_chrpoll()
Thread-Topic: [patch -next] xshm: calling unlock improperly in
 xshmchr_chrpoll()
Thread-Index: Acy13v5YzEwvp19BTBqDV3Q/yNgC8QAkK70Q
Message-ID: <81C3A93C17462B4BBD7E272753C105791FB0D6B448@EXDCVYMBSTM005.EQ1STM.local>
References: <20111208192402.GA8810@elgon.mountain>
In-Reply-To: <20111208192402.GA8810@elgon.mountain>
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

Hi Dan,

> We got interrupted before we could take the lock here, and so we
> shouldn't call unlock.

Acked-by: Sjur Brændeland <sjur.brandeland@stericsson.com>
> Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>

Thank you for spotting this.
I will include this patch when I send out a new patch-set.

Regards,
Sjur
