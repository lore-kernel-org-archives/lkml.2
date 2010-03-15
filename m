Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964968Ab0COXeO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Mar 2010 19:34:14 -0400
Received: from mail-qy0-f191.google.com ([209.85.221.191]:47203 "EHLO
	mail-qy0-f191.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932380Ab0COXeK convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Mar 2010 19:34:10 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=LivaM/BxaOggOakVxkCnRycB8et+3mSgBS6p9p8HjQZeRhS4Cdo2Js8N8o6FJslZP6
         xP7jyLYBiQhwrGLcm5UNbnovWuiYT/4tzhk1gZzGkFQMvDEO/VSA+daRJlsEa/CuUcPN
         bTQP2s2LjYipF7DyHTU5Kmu8p4otn/0BauAgY=
MIME-Version: 1.0
In-Reply-To: <201003152227.11295.rjw@sisk.pl>
References: <201002272143.22156.rjw@sisk.pl>
	 <3f9a31f41002281213y2d65ae37xf9934a0775d8d9ee@mail.gmail.com>
	 <20100315201659.GA6757@kroah.com> <201003152227.11295.rjw@sisk.pl>
Date: Tue, 16 Mar 2010 05:04:09 +0530
Message-ID: <3f9a31f41003151634k5f8521c0l99179bcf02d9e551@mail.gmail.com>
Subject: Re: [PATCH] Driver core: Reduce the level of request_firmware() 
	messages
From: Jaswinder Singh Rajput <jaswinderlinux@gmail.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Greg KH <greg@kroah.com>, Greg KH <gregkh@suse.de>,
       LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       David Woodhouse <dwmw2@infradead.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Rafael,

On Tue, Mar 16, 2010 at 2:57 AM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
>
> I still think it's a good idea.  The information about what firmware is being
> used doesn't seem to be very useful for anything but debugging, so I think
> KERN_DEBUG is actually the right level for these messages.
>

Can we use printk_once()

Thanks,
--
Jaswinder Singh.
