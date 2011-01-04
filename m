Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751430Ab1ADVKg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Jan 2011 16:10:36 -0500
Received: from mail-ew0-f46.google.com ([209.85.215.46]:58350 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750980Ab1ADVKf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Jan 2011 16:10:35 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:reply-to:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-type:content-transfer-encoding:message-id;
        b=n9tbYFVGZsqDEN9ssaX/12z8sgghqGvNESpL6oYUkA0FiTUy41SXGwGFyeS9/EZIY/
         GHZ1jjFJiH4fRciO+5nh+bC3LJhUic3YUEVLB2jPHAX6+lSxgmIpvKESXbBS6Z5A2lDp
         arZydCyvgTWO1MoP9zaK2O3E85/r99EAJv3Qc=
From: Maciej Rutecki <maciej.rutecki@gmail.com>
Reply-To: maciej.rutecki@gmail.com
To: Bob Tracy <rct@gherkin.frus.com>
Subject: Re: [BUG] implicit declaration of kfree/kzalloc in i2c-i801.c on Alpha
Date: Tue, 4 Jan 2011 22:10:29 +0100
User-Agent: KMail/1.13.5 (Linux/2.6.37-rc8; KDE/4.4.5; i686; ; )
Cc: linux-kernel@vger.kernel.org, linux-alpha@vger.kernel.org,
        mcree@orcon.net.nz
References: <20110104061821.GA25886@gherkin.frus.com>
In-Reply-To: <20110104061821.GA25886@gherkin.frus.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201101042210.30076.maciej.rutecki@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I created a Bugzilla entry at 
https://bugzilla.kernel.org/show_bug.cgi?id=26132
for your bug report, please add your address to the CC list in there, thanks!

On wtorek, 4 stycznia 2011 o 07:18:21 Bob Tracy wrote:
> Another 2.6.37-rc8 build failure on alpha:
> 
> (...)
>   CC [M]  drivers/i2c/busses/i2c-i801.o
> drivers/i2c/busses/i2c-i801.c: In function 'i801_probe':
> drivers/i2c/busses/i2c-i801.c:737: error: implicit declaration of function
> 'kzalloc' drivers/i2c/busses/i2c-i801.c:737: warning: assignment makes
> pointer from integer without a cast drivers/i2c/busses/i2c-i801.c:855:
> error: implicit declaration of function 'kfree' make[3]: ***
> [drivers/i2c/busses/i2c-i801.o] Error 1
> make[2]: *** [drivers/i2c/busses] Error 2
> make[1]: *** [drivers/i2c] Error 2
> make: *** [drivers] Error 2
> 
> --Bob
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

-- 
Maciej Rutecki
http://www.maciek.unixy.pl
