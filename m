Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751602Ab2DQUrS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Apr 2012 16:47:18 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:52220 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751173Ab2DQUrR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Apr 2012 16:47:17 -0400
Date: Tue, 17 Apr 2012 13:47:12 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Ivo Sieben <meltedpianoman@gmail.com>
Cc: Remy Bohmer <linux@bohmer.net>, Chris Wright <chrisw@sous-sol.org>,
        linux-kernel@vger.kernel.org, Jean Delvare <khali@linux-fr.org>,
        Kevin Hilman <khilman@deeprootsystems.com>,
        Wolfram Sang <w.sang@pengutronix.de>
Subject: Re: [PATCH-v3] Support M95040 SPI EEPROM
Message-ID: <20120417204712.GC3120@kroah.com>
References: <20120403170708.GC2477@pengutronix.de>
 <20120403171112.GH19952@sequoia.sous-sol.org>
 <20120403171736.GD2477@pengutronix.de>
 <CAMSQXEHpjD7LWQkKWJOU=9eFYqsaJi-xHFTxexQr7yoKiCG7HQ@mail.gmail.com>
 <20120404075956.GB9073@pengutronix.de>
 <CAMSQXEHxaJpmjpOz_VL54bs1W9x3kCJKGoeTCmBpZva_hSTVsw@mail.gmail.com>
 <20120405164354.GC16546@kroah.com>
 <CANqCtQJjzkANJQMd8E9XKvOyk_FLCm1ER=VznrQ+cAerGbO0zQ@mail.gmail.com>
 <20120406182237.GB13649@pengutronix.de>
 <CAMSQXEHXQOH7k=aLzXZyxnBQmPwXkrvx8J6brPEWUyFfV-b6pQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAMSQXEHXQOH7k=aLzXZyxnBQmPwXkrvx8J6brPEWUyFfV-b6pQ@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 17, 2012 at 04:43:54PM +0200, Ivo Sieben wrote:
> >> Is this acceptable for you Greg?
> >
> > If so, don't forget my
> >
> > Reviewed-by: Wolfram Sang <w.sang@pengutronix.de>
> >
> > given to the original patch.
> >
> 
> Greg, what's the status on this patch?
> Is it acceptable for you, or do you want me to resend the patch
> (including the "Reviewed-by" tag)

Please resend it, as all I seem to be able to find is a base64
attachment, which is a pain to deal with...

greg k-h
