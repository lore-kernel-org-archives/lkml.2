Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758256Ab2K0Hjp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Nov 2012 02:39:45 -0500
Received: from mail-ee0-f46.google.com ([74.125.83.46]:47901 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757559Ab2K0Hjn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Nov 2012 02:39:43 -0500
Date: Tue, 27 Nov 2012 10:36:57 +0300
From: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
To: joeyli <jlee@suse.com>
Cc: Joey Lee <jlee@novell.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] acer-wmi: add Aspire 5741G touchpad toggle key
Message-ID: <20121127073657.GB2726@swordfish.minsk.epam.com>
References: <20121126183502.GA2749@swordfish>
 <1353997912.21227.862.camel@linux-s257.site>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1353997912.21227.862.camel@linux-s257.site>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On (11/27/12 14:31), joeyli wrote:
> 於 一，2012-11-26 於 21:35 +0300，Sergey Senozhatsky 提到：
> > Add Aspire 5741G KEY_TOUCHPAD_TOGGLE to wmi keymap, preventing
> > "acer_wmi: Unknown key number - 0x85" error.
> > 
> > 
> > Signed-off-by: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
> 
> Signed-off-by: Lee, Chun-Yi <jlee@suse.com>
> 
> Thanks for you resend your patch. 
>

sorry, it took so much time, somehow I forgot about it.

	-ss

> Joey Lee
> 
> > 
> > ---
> > 
> >  drivers/platform/x86/acer-wmi.c | 1 +
> >  1 file changed, 1 insertion(+)
> > 
> > diff --git a/drivers/platform/x86/acer-wmi.c b/drivers/platform/x86/acer-wmi.c
> > index 934d861..9a6ee9a 100644
> > --- a/drivers/platform/x86/acer-wmi.c
> > +++ b/drivers/platform/x86/acer-wmi.c
> > @@ -127,6 +127,7 @@ static const struct key_entry acer_wmi_keymap[] = {
> >  	{KE_IGNORE, 0x81, {KEY_SLEEP} },
> >  	{KE_KEY, 0x82, {KEY_TOUCHPAD_TOGGLE} },	/* Touch Pad On/Off */
> >  	{KE_IGNORE, 0x83, {KEY_TOUCHPAD_TOGGLE} },
> > +	{KE_KEY, 0x85, {KEY_TOUCHPAD_TOGGLE} },
> >  	{KE_END, 0}
> >  };
> > 
> > 
> 
> 
