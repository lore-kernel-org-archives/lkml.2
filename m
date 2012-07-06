Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933119Ab2GFVaW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jul 2012 17:30:22 -0400
Received: from mail-yw0-f46.google.com ([209.85.213.46]:54636 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932123Ab2GFVaV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jul 2012 17:30:21 -0400
Date: Fri, 6 Jul 2012 14:30:16 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Christian Lamparter <chunkeey@googlemail.com>
Cc: linux-pcmcia@lists.infradead.org, linux-kernel@vger.kernel.org,
        Dominik Brodowski <linux@dominikbrodowski.net>
Subject: Re: [RESEND AGAIN][PATCH] pcmcia: move unbind/rebind into
 dev_pm_ops.complete
Message-ID: <20120706213016.GA15424@kroah.com>
References: <201207062323.52785.chunkeey@googlemail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201207062323.52785.chunkeey@googlemail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 06, 2012 at 11:23:52PM +0200, Christian Lamparter wrote:
> The idea of moving rebind procedure into pm.complete
> was taken from the usb-subsystem, which has similar
> problems with reattaching devices during/after
> resume.
> 
> Signed-off-by: Christian Lamparter <chunkeey@googlemail.com>
> ---
> To Greg:
> 
> I have submitted this patch back in March and again in May.
> As far as I can tell it was neither rejected nor was it
> accepted into linux-pcmcia.git since. So I'm asking you,
> if you could take the patch instead... please.

There is a PCMCIA "team" who should be taking these types of patches.
Why are they not doing so?

confused,

greg k-h
