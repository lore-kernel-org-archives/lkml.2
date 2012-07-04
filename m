Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933013Ab2GDBsO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jul 2012 21:48:14 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:59234 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932541Ab2GDBsL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jul 2012 21:48:11 -0400
From: "Du, Changbin" <changbin.du@gmail.com>
To: "'Sergei Shtylyov'" <sshtylyov@mvista.com>
Cc: <balbi@ti.com>, <gregkh@linuxfoundation.org>, <ben@simtec.co.uk>,
        <linux-usb@vger.kernel.org>, <linux-kernel@vger.kernel.org>
References: <4ff252e7.08d4440a.38ee.ffffd7b9@mx.google.com> <4FF329F5.6000801@mvista.com>
In-Reply-To: <4FF329F5.6000801@mvista.com>
Subject: RE: [PATCH 1/1] usb: gadget: s3c-hsotg: fix core reset timeout failure
Date: Wed, 4 Jul 2012 09:48:01 +0800
Message-ID: <4ff3a0da.cae2440a.7e4a.328e@mx.google.com>
MIME-Version: 1.0
Content-Type: text/plain;
	charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-Index: Ac1ZQGftjd+FTgsuS9yT1CXtzR13YQARhBLA
Content-Language: zh-cn
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > Seeing from above values, I think 10000 is big enough.
> 
> > Signed-off-by: Du, Changbin <changbin.du@gmail.com>
> > ---
> >  drivers/usb/gadget/s3c-hsotg.c |    4 ++--
> >  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> > diff --git a/drivers/usb/gadget/s3c-hsotg.c
b/drivers/usb/gadget/s3c-hsotg.c
> > index f4abb0e..f3e2234 100644
> > --- a/drivers/usb/gadget/s3c-hsotg.c
> > +++ b/drivers/usb/gadget/s3c-hsotg.c
> > @@ -2215,7 +2215,7 @@ static int s3c_hsotg_corereset(struct s3c_hsotg
> > *hsotg)
> 
>   Your patch is line wrapped; seems easy to fix manually while applying
> though...

Sorry, it's done by my mail client. I will send a new one soon. Thanks for
pointing out it.

Du, Changbin

> 
> WBR, Sergei

