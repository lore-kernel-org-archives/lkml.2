Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752013Ab0IMOeM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Sep 2010 10:34:12 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:41715 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751208Ab0IMOeK convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Sep 2010 10:34:10 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=YlgsZc3xSlL1WEng6qooNSBwJLaDpeR4EmJZZn325ibcmInYT+RSCKVJ85znyP5sDn
         SFXhOZdx5I0U0IwRb3DwzrX6TPYObLnjoQ7ir2I4zsOuSqrU6dVqlNtn2CRC42aqFQa9
         STFv/iQ/+G6ITXzISkupPwUEGEYfxZHKXJwkA=
MIME-Version: 1.0
In-Reply-To: <4C8E18AD.8000502@ru.mvista.com>
References: <1283873014-32511-1-git-send-email-tom.leiming@gmail.com>
	<1283873014-32511-6-git-send-email-tom.leiming@gmail.com>
	<4C8E18AD.8000502@ru.mvista.com>
Date: Mon, 13 Sep 2010 22:34:08 +0800
Message-ID: <AANLkTinei3u1OZ-eBiUTDF=PDjwxLcL6rBpt7iNQJgHJ@mail.gmail.com>
Subject: Re: [RESEND/PATCH 5/6] USB: musb-gadget: complete request only if
 data is transfered over
From: Ming Lei <tom.leiming@gmail.com>
To: Sergei Shtylyov <sshtylyov@mvista.com>
Cc: greg@kroah.com, linux-usb@vger.kernel.org, linux-omap@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        David Brownell <dbrownell@users.sourceforge.net>,
        Felipe Balbi <balbi@ti.com>, Anand Gadiyar <gadiyar@ti.com>,
        Mike Frysinger <vapier@gentoo.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2010/9/13 Sergei Shtylyov <sshtylyov@mvista.com>:
>   But why not modify the conditional above all that code, just excluding
> 'is_dma' from it. This conditional already includes (request->actual ==
> request->length) check. Please recast this patch.

The two condition is OR relation, not and, so we can't exclude 'is_dma' simply.
Anyway, the change is not wrong, right?


thanks,
-- 
Lei Ming
