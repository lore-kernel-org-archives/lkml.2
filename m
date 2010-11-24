Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752885Ab0KXKHk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Nov 2010 05:07:40 -0500
Received: from mail-vw0-f46.google.com ([209.85.212.46]:40400 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752407Ab0KXKHj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Nov 2010 05:07:39 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=rhzUDOFuAtXUzGUmr/RXFY7HkCoghz52CSO2e0Ma0Ahdnw6oeoeoVQGEYS+2cnzBgL
         Bj9yqaIEPr3enW56qD56j+F8TG3pK4Tp1rpmr0fxqwWcps9v0zOnJCQgbYoGK8+nSn1m
         /DcCTfcKdPvnBHtJThm4C0MF122O+heL4stuk=
Date: Wed, 24 Nov 2010 18:12:25 +0800
From: =?utf-8?Q?Am=C3=A9rico?= Wang <xiyou.wangcong@gmail.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Linux 2.6.37-rc3
Message-ID: <20101124101225.GB5139@cr0.nay.redhat.com>
References: <AANLkTi=Di4UQMYyJ_wpZ6N=NZt1+3EeXL7FUsBX004YL@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AANLkTi=Di4UQMYyJ_wpZ6N=NZt1+3EeXL7FUsBX004YL@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, Linus,

Seems this patch from me is still not merged?

We need to add recordmcount into .gitignore,
it is a generated file, otherwise git will complain.

Thanks!

Signed-off-by: WANG Cong <xiyou.wangcong@gmail.com>

---

diff --git a/scripts/.gitignore b/scripts/.gitignore
index c5d5db5..e2741d2 100644
--- a/scripts/.gitignore
+++ b/scripts/.gitignore
@@ -7,3 +7,4 @@ pnmtologo
 bin2c
 unifdef
 ihex2fw
+recordmcount
