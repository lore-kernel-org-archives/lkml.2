Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932586Ab0FKWNN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jun 2010 18:13:13 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:44667 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754891Ab0FKWNM convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jun 2010 18:13:12 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=ZPqPwIqclL9pFcI2YBcvIaMNy5QC0WgRXU+2Qsm6klhPySRAEtZ5SSZKhI5W+pLvF5
         tQzQKvM3BRUG+5VNCLSoXruO48zoqSPLEFOoP+pFlqCfw8u00ZmlcQ31l5DbhMehcI8j
         RFiCJXF7VPge0ss2GvuNaiSCWaNjUJ/AtDpD4=
MIME-Version: 1.0
In-Reply-To: <1276275156.1637.52.camel@Joe-Laptop.home>
References: <1276238148.22216.30.camel@lenovo> <1276238502.1556.512.camel@Joe-Laptop.home> 
	<AANLkTikH_CAVo7sblakUfhI-ysIXk2z1KZz0YkjCDL3m@mail.gmail.com> 
	<1276275156.1637.52.camel@Joe-Laptop.home>
From: Javier Martinez Canillas <martinez.javier@gmail.com>
Date: Fri, 11 Jun 2010 18:12:56 -0400
Message-ID: <AANLkTimJqo86Gl34ToKx9TDhExL9eAks6b68ryB9u4cn@mail.gmail.com>
Subject: Re: [PATCH] staging/wlags49_hs: Fix build error when CONFIG_SYSFS is 
	not set
To: Joe Perches <joe@perches.com>
Cc: Henk de Groot <pe1dnn@amsat.org>, devel@driverdev.osuosl.org,
       Greg Kroah-Hartman <gregkh@suse.de>,
       kernel-janitors <kernel-janitors@vger.kernel.org>,
       linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 11, 2010 at 12:52 PM, Joe Perches <joe@perches.com> wrote:
> On Fri, 2010-06-11 at 08:46 -0400, Javier Martinez Canillas wrote:
>
> Check the general kernel use of macros vs functions.
> Functions verify proper arguments, macros do not.
>
>
>

I see. thank you very much for clarify this. I'm will generate a
correct patch and resend.

Best regards,

-----------------------------------------
Javier Martínez Canillas
+595 981 88 66 58
