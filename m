Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755291Ab0LIBil (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Dec 2010 20:38:41 -0500
Received: from mail-gw0-f42.google.com ([74.125.83.42]:54751 "EHLO
	mail-gw0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752156Ab0LIBij (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Dec 2010 20:38:39 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type;
        b=J5J2NHntWWXftWY1IOJuW/MYvuhW/WGjQx/GWXEIXg0lclFzDvGLZVJ3uN3KJjot9C
         nAQRv463OBwQ96/geA8dThKiCFfQUD3jZYLNdgmf65qjmrf41tuzX84w4ZRiTTW/HVka
         XtNZgE63HOJkS3DdzJKYi2lJvgZkDLw8mKJb0=
MIME-Version: 1.0
In-Reply-To: <AANLkTink9aX=dV-+n5=2BpPF34kSZGSQQ6x2tUNJ8eSM@mail.gmail.com>
References: <1291721340-22652-1-git-send-email-rydberg@euromail.se>
 <4CFFC3C2.1080905@canonical.com> <AANLkTikmomm2hd7AAJMTnY+=J2wPyVvodv2Ft0jFe7w2@mail.gmail.com>
 <20101208235805.GE15294@core.coreip.homeip.net> <AANLkTink9aX=dV-+n5=2BpPF34kSZGSQQ6x2tUNJ8eSM@mail.gmail.com>
From: Mohamed Ikbel Boulabiar <boulabiar@gmail.com>
Date: Thu, 9 Dec 2010 02:38:18 +0100
Message-ID: <AANLkTi=rjbzX9zzx-xvvhu7osKU8eUiPxi2=z=9H6YwJ@mail.gmail.com>
Subject: Re: [PATCH] input: mt: Add an envelope tool type
To: Ping Cheng <pinglinux@gmail.com>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Chase Douglas <chase.douglas@canonical.com>,
        Henrik Rydberg <rydberg@euromail.se>, Jiri Kosina <jkosina@suse.cz>,
        linux-input@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 9, 2010 at 1:06 AM, Ping Cheng <pinglinux@gmail.com> wrote:
> No, we are not talking about non-rectangular shape here. Envelop is
> always a rectangle. By rectangle above, I meant 2 touches.
>
> An envelop that includes number of touches offers us more information
> than a rectangle does

Can we have more information that just a rect ? An ellipse for exemple.
Can we get this information at least from synaptics touchpads?


i
