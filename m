Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753441Ab1EYSln (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 May 2011 14:41:43 -0400
Received: from mail-gw0-f46.google.com ([74.125.83.46]:56238 "EHLO
	mail-gw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752545Ab1EYSll (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 May 2011 14:41:41 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=rzkZ4om09ZKgGGHVjH/IwCuxeeYp7sbPqZm6WTDWYoWPpiPy0pMLR2W3scLET81kfD
         5uVWIljChxlhHOlDIosXVnpXZXBDwvl98SDCZggfy1aQABANhiGHbnkVgPfKPwg7+7aB
         OjwaBgXmDcskdym5UEmj0vew3fkzoXxJVgC+Q=
MIME-Version: 1.0
In-Reply-To: <BANLkTimxi-LZFzwv=z6RRBCX098hr-ViUg@mail.gmail.com>
References: <1306266871-12464-1-git-send-email-lxnay@sabayon.org>
	<20110524224545.08c53b1d@neptune.home>
	<20110525181917.12cf97b8@neptune.home>
	<BANLkTimxi-LZFzwv=z6RRBCX098hr-ViUg@mail.gmail.com>
Date: Wed, 25 May 2011 21:41:40 +0300
Message-ID: <BANLkTi=Q5EzN+wP9jDNCxCnZBQ0XHOmOhQ@mail.gmail.com>
Subject: Re: [PATCH] fbmem: fix race condition between register_framebuffer()
 and fb_open()
From: Anca Emanuel <anca.emanuel@gmail.com>
To: Fabio Erculiani <lxnay@sabayon.org>
Cc: =?ISO-8859-1?Q?Bruno_Pr=E9mont?= <bonbons@linux-vserver.org>,
        linux-fbdev@vger.kernel.org, lethal@linux-sh.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 25, 2011 at 9:17 PM, Fabio Erculiani <lxnay@sabayon.org> wrote:
> I'm not a fbdev expert. So I leave the real fix to real men ( ;-) ).
> It is causing deadlock during boot, so I would consider it quite critical.
> Users using any fb driver will get into troubles.
> The workaround is to boot with vga=normal.

Did you test 2.6.39 ? The fix from Linus is not ok ?
