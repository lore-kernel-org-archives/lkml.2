Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756724Ab1DLGur (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Apr 2011 02:50:47 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:44870 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754215Ab1DLGuq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Apr 2011 02:50:46 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=xrdJFrZ2+rWtYO4Xnw2G4lwsFAEze3+lvxs/hSx+cLBJUEQgIhEJ6q+mjI/frg3woA
         9/4/9Eolh47SFON5PlCjIETRt3px4PMLXjORTgwfWBoiRZoLhLc7EjUmXIVHNWHCesmX
         oxXG5BUiTuwzuzJiW9rJJbtTDnvHS+HmctviI=
Date: Mon, 11 Apr 2011 23:50:40 -0700
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Axel Lin <axel.lin@gmail.com>
Cc: linux-kernel@vger.kernel.org,
        David Brownell <dbrownell@users.sourceforge.net>,
        Felipe Balbi <balbi@ti.com>, linux-input@vger.kernel.org
Subject: Re: [PATCH RESEND] Input: twl4030_keypad - fix potential NULL
 dereference in twl4030_kp_probe()
Message-ID: <20110412065040.GB9566@core.coreip.homeip.net>
References: <1302590871.17965.1.camel@phoenix>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1302590871.17965.1.camel@phoenix>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 12, 2011 at 02:47:51PM +0800, Axel Lin wrote:
> We should first check whether platform data is NULL or not, before
> dereferencing it to get the keymap.
> 
> Signed-off-by: Axel Lin <axel.lin@gmail.com>
> Reviewed-by: Felipe Balbi <balbi@ti.com>

Hmm, I thought I already applied it but I guess I managed to loose it.
Let's try again...

Thanks.

-- 
Dmitry
