Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756803Ab1KQLX6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Nov 2011 06:23:58 -0500
Received: from mail-fx0-f46.google.com ([209.85.161.46]:40848 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753273Ab1KQLX4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Nov 2011 06:23:56 -0500
Subject: Re: [PATCH] usb : gadget : usbstring : fix style problems
From: Tonylijo <mail@tonylijo.in>
To: balbi@ti.com
Cc: linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org
In-Reply-To: <20111116110912.GD27980@legolas.emea.dhcp.ti.com>
References: <1321418582.2443.4.camel@debian1.ic>
	 <20111116110912.GD27980@legolas.emea.dhcp.ti.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 17 Nov 2011 16:15:57 +0530
Message-ID: <1321526757.2367.20.camel@debian1.ic>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2011-11-16 at 13:09 +0200, Felipe Balbi wrote:
> On Wed, Nov 16, 2011 at 10:13:02AM +0530, Tonylijo wrote:
> > Minor fixes for problems found by checkpatch.pl in usbstring.c.
> 
> list here the return from checkpatch.pl --terse just so we know what
> you're fixing.
> 
> > Signed-off-by: Tonylijo Jose <mail@tonylijo.in>
> > ---
> > diff --git a/drivers/usb/gadget/usbstring.c
> > b/drivers/usb/gadget/usbstring.c
> > index 58c4d37..2bdc56a 100644
> > --- a/drivers/usb/gadget/usbstring.c
> > +++ b/drivers/usb/gadget/usbstring.c
> > @@ -32,8 +32,9 @@ static int utf8_to_utf16le(const char *s, __le16 *cp,
> > unsigned len)
> >  	 */
> >  	while (len != 0 && (c = (u8) *s++) != 0) {
> >  		if (unlikely(c & 0x80)) {
> > -			// 2-byte sequence:
> > -			// 00000yyyyyxxxxxx = 110yyyyy 10xxxxxx
> > +			/* 2-byte sequence:
> > +			 * 00000yyyyyxxxxxx = 110yyyyy 10xxxxxx
> > +			 */
> 
> still wrong. This should've been:
> 
> /*
>  * 2-byte sequence
>  * 00000yyyyyxxxxxx = 110yyyyy 10xxxxxx
>  */
> 
> likewise all bellow.
> 
Thanks for your review. I will send the corrected patch soon.


