Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751358Ab0IHEcV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Sep 2010 00:32:21 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:37176 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750946Ab0IHEcT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Sep 2010 00:32:19 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=Qk6EZuwylJNAUtZ5XvdOodHkOAODNx/nlP++xHoQnK5LxhuB1Mp3nzVZn4x0aVlUc8
         T6ndMjeJIvJ/odlTmfCN9PMDc36owEDfcjZ+g0yw00RkUU6LH+7NcmRHkAcpapZER1+s
         74k2bBEIN83YfH5xgtMr7zT4zl45Q8lGy0bIk=
MIME-Version: 1.0
In-Reply-To: <20100908021939.GA20443@kroah.com>
References: <1283873014-32511-1-git-send-email-tom.leiming@gmail.com>
	<20100908021939.GA20443@kroah.com>
Date: Wed, 8 Sep 2010 12:32:19 +0800
Message-ID: <AANLkTim605xLy8LjaKO+wR+UX2_r-dEQr=bMasXLAk22@mail.gmail.com>
Subject: Re: [RESEND/PATCH 0/6] USB: musb-gadget: bug fix
From: Ming Lei <tom.leiming@gmail.com>
To: Greg KH <greg@kroah.com>
Cc: linux-usb@vger.kernel.org, linux-omap@vger.kernel.org,
        linux-kernel@vger.kernel.org, Felipe Balbi <me@felipebalbi.com>,
        David Brownell <dbrownell@users.sourceforge.net>,
        "Gadiyar, Anand" <gadiyar@ti.com>, Mike Frysinger <vapier@gentoo.org>,
        Sergei Shtylyov <sshtylyov@ru.mvista.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

CC Felipe / David / Gadiyar / Mike /  Sergei

2010/9/8 Greg KH <greg@kroah.com>:
> I seem to not have 1/6 here, did it get stuck somewhere?

Here is 1/6:

         http://marc.info/?l=linux-usb&m=128387307419605&w=2

If you need, I can send the 1/6 to you directly.

>
> Anyway, I need Felipe's ack before I can accept these.

Felipe, expect your comments on the patch set...

BTW: The mailbox of felipe.balbi@nokia.com in MAINTAINERS has been
obsolete now, and his current box is me@felipebalbi.com, seems MAINTAINERS
should be updated for it.

-- 
Lei Ming
