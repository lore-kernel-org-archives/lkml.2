Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752618Ab0KDSy5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Nov 2010 14:54:57 -0400
Received: from mail-ey0-f174.google.com ([209.85.215.174]:57973 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751857Ab0KDSyz convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Nov 2010 14:54:55 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:reply-to:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-type:content-transfer-encoding:message-id;
        b=cxMaqk9AWtw/umXNvwuK7ORJkcYZhVN0GCr12i4n9OhCG+OaNWhBqWmBorULa+qpxJ
         K/LioYja+N5ein7N1b/RQCP3i3Ke9cHS/YMAx1p3iCOfRycqZu3ez6SUi1DNcnfinhKs
         2tT0vM/C0XeMB9cgEwlyo14HefOQkys3CkmYU=
From: Maciej Rutecki <maciej.rutecki@gmail.com>
Reply-To: maciej.rutecki@gmail.com
To: Antonio Ospite <ospite@studenti.unina.it>
Subject: Re: gspca for_2.6.36 - maybe does not work properly for me (ov534)
Date: Thu, 4 Nov 2010 19:54:48 +0100
User-Agent: KMail/1.13.5 (Linux/2.6.37-rc1; KDE/4.4.5; i686; ; )
Cc: =?utf-8?q?T=C3=B5nu_Samuel?= <tonu@jes.ee>, linux-usb@vger.kernel.org,
        linux-media@vger.kernel.org,
        "linux-kernel" <linux-kernel@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@redhat.com>
References: <1288264077.1891.40.camel@x41.itrotid.ee> <201011032007.25474.maciej.rutecki@gmail.com> <20101103215339.bf451689.ospite@studenti.unina.it>
In-Reply-To: <20101103215339.bf451689.ospite@studenti.unina.it>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-Id: <201011041954.48985.maciej.rutecki@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On środa, 3 listopada 2010 o 21:53:39 Antonio Ospite wrote:
> On Wed, 3 Nov 2010 20:07:25 +0100
> 
> Maciej Rutecki <maciej.rutecki@gmail.com> wrote:
> > (add CC's)
> > 
> > On czwartek, 28 października 2010 o 13:07:57 Tõnu Samuel wrote:
> > > I am Sony PS3 Eye webcam user.
> 
> Please more context in the Subject next time :)
> 
> > > After installing 2.6.36 this camera gets recognized but actually does
> > > not work. It might be some own stupidity of improper kernel
> > > configuration but I cannot track it down at moment.
> 
> This is fixed in 2.6.37-rc1, Mauro this should go in 2.6.36.1 as well,
> ASAP please as we missed 2.6.36.
> 
> This is the thread:
> http://www.mail-archive.com/linux-media@vger.kernel.org/msg23039.html
> 
> This is the patch:
> http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h
> =f43402fa55bf5e7e190c176343015122f694857c
> 
> Regards,
>    Antonio

Thanks for the information.

Regards
-- 
Maciej Rutecki
http://www.maciek.unixy.pl
