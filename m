Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753944Ab0L2V3L (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Dec 2010 16:29:11 -0500
Received: from mail-pw0-f46.google.com ([209.85.160.46]:51621 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753314Ab0L2V3G (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Dec 2010 16:29:06 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=QHf/AuVpXC2u7CbVhIXVJ0knaX3RY3kw2EHNL5SmficPKJcsfCti64I2Bklp/Y/CnE
         WSv7R4ht85F7Pc1lk2/TKwGpQN09vF/xbf7CFE8zrB/mHMqh2HS7jSvzJeoqqqCWfEyu
         Eox18VGpB7Q9gbqM1Sr+0WOhbMTeO6xaPcaDQ=
MIME-Version: 1.0
In-Reply-To: <33A307AF30D7BF4F811B1568FE7A9B18047CAF8DF1@EXDCVYMBSTM006.EQ1STM.local>
References: <20101223223634.8c92ef31.sfr@canb.auug.org.au>
	<20101227162021.de3af7bc.sfr@canb.auug.org.au>
	<AANLkTinjwN2-cVy8qsemuPOntPy-x0WS9_3t-Hc4xh0+@mail.gmail.com>
	<33A307AF30D7BF4F811B1568FE7A9B18047CAF8DF1@EXDCVYMBSTM006.EQ1STM.local>
Date: Wed, 29 Dec 2010 22:29:05 +0100
Message-ID: <AANLkTi=w3qq9SNi3r0bDH_VBQx_t7Mve3fXPDu2hOAVu@mail.gmail.com>
Subject: Re: linux-next: build failure after merge of the final tree
 (ux500-core tree related)
From: Linus Walleij <linus.ml.walleij@gmail.com>
To: Sundar R IYER <sundar.iyer@stericsson.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>,
        "linux-next@vger.kernel.org" <linux-next@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Dmitry Torokhov <dtor@mail.ru>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2010/12/28 Sundar R IYER <sundar.iyer@stericsson.com>:

> Here is the patch which fixes this build issues. I am very sorry for the inconvenience caused.

Such things happen. This patch was badly whitespace mangled after som
experience with Outlook and/or Exchange, but I fixed it up anyway :-)

Yours,
Linus Walleij
