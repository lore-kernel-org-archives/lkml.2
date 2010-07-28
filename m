Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754156Ab0G1Nmg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jul 2010 09:42:36 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:57672 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751894Ab0G1Nmf convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jul 2010 09:42:35 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=ojguiQagjTqwrT5v822s93trUAcL4CCEDuqCdRbrZrTy+WUnhTrgpJBEobLFTNk6yp
         RVXKbwntK5iUpeKp18zu0VpfU1VUVaWsNnQizqENhT9wT20S/oRLjUQU9CdmYNOnbJq5
         si9xmcPbjswhcZcZlvdLevxjpBaEzDm8Y6HUQ=
MIME-Version: 1.0
In-Reply-To: <op.vgj05nev7p4s8u@pikus>
References: <38424b23c94ddcff6f1808161912f362c2ccae39.1280316431.git.m.nazarewicz@samsung.com>
	<7b3ddf05e135e8147d1011a81f9069d9cd78aa62.1280316431.git.m.nazarewicz@samsung.com>
	<d7a11c97d1b28c7a0336c747de57a9a17dcc7604.1280316431.git.m.nazarewicz@samsung.com>
	<AANLkTikW8eSn3fgRqJsXwp=+ZMjKgojHDP6+DsDMtg4y@mail.gmail.com>
	<op.vgj05nev7p4s8u@pikus>
Date: Wed, 28 Jul 2010 16:42:33 +0300
Message-ID: <AANLkTimavNK1cFhOndEBJrz0NWDn+GUYsLkBDEN9XFwr@mail.gmail.com>
Subject: Re: [PATCHv5 3/3] USB: gadget: storage_common: fixed warning building 
	mass storage function
From: Andy Shevchenko <andy.shevchenko@gmail.com>
To: =?UTF-8?Q?Micha=C5=82_Nazarewicz?= <m.nazarewicz@samsung.com>
Cc: Greg KH <greg@kroah.com>, David Brownell <david-b@pacbell.net>,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2010/7/28 Michał Nazarewicz <m.nazarewicz@samsung.com>:
>> Why the warning happens for those two only?
>> There are two more parameters (four methods) to handle 'ro' and 'file'
>> which are done in the same way.
>
> Those are the only ones that are not used by the mass storage function.
Now I got it.

I'm just wondering if it somehow useful to append similar parameter to
that function.

-- 
With Best Regards,
Andy Shevchenko
