Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756813Ab0LICs4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Dec 2010 21:48:56 -0500
Received: from mail-bw0-f45.google.com ([209.85.214.45]:42772 "EHLO
	mail-bw0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754689Ab0LICsz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Dec 2010 21:48:55 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=n+uY31ly2p8Wms12bhHjg3oMHnr5DofkbX1eASZQF9P9PWZ1OeOXFgHc5JfGoAL7VI
         d9FnvxtSnvSAKsycUKQ3om31Jwgd84GqOzXca/SQarzmb1b0Yc3tpe9ZJkEh8eYUu7jJ
         QX2W5jGtA5pHuuoFGgWBBDFEuj9OgjaYWsUzA=
Subject: Re: MEMSTICK: Add my 2 drivers
From: Maxim Levitsky <maximlevitsky@gmail.com>
To: Alex Dubov <oakad@yahoo.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Takashi Iwai <tiwai@suse.de>
In-Reply-To: <619119.14301.qm@web37606.mail.mud.yahoo.com>
References: <619119.14301.qm@web37606.mail.mud.yahoo.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 09 Dec 2010 04:48:49 +0200
Message-ID: <1291862929.7792.30.camel@maxim-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2010-12-08 at 18:44 -0800, Alex Dubov wrote:
> > 
> > Since I don't touch (and don't want anymore to) any code
> > written by
> > Alex, and I even added workarounds for bugs in his jmicron
> > driver to the
> > generic ms_block.c code (it tested and works on my both
> > card readers),
> > maybe even add these to 2.6.37?
> 
> This are worked around by the recent patches, are not they?
I don't care, really.
This is your code, I don't want another frustration and flamewar.
I will eventually test your patches (I did see them before I send that
mail), if they don't work, I just ask for a revert.

Best regards,
	Maxim Levitsky

