Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752953Ab1EJV7a (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 May 2011 17:59:30 -0400
Received: from kroah.org ([198.145.64.141]:54736 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751361Ab1EJV73 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 May 2011 17:59:29 -0400
Date: Tue, 10 May 2011 14:59:21 -0700
From: Greg KH <greg@kroah.com>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Patrik Jakobsson <patrik.r.jakobsson@gmail.com>, alan@linux.intel.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] gma500: Add option to disable LVDS
Message-ID: <20110510215921.GB12854@kroah.com>
References: <20110510212038.GA3279@patrik-macbook>
 <20110510224602.73b24d0a@lxorguk.ukuu.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110510224602.73b24d0a@lxorguk.ukuu.org.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 10, 2011 at 10:46:02PM +0100, Alan Cox wrote:
> On Tue, 10 May 2011 23:20:38 +0200
> Patrik Jakobsson <patrik.r.jakobsson@gmail.com> wrote:
> 
> > This patch adds the option to load the driver without LVDS support. Some platforms with the gma500 have nothing hooked up to LVDS but only uses SDVO. LVDS is still detected and added as an encoder which causes SDVO mode-setting to fail.
> > 
> > Signed-off-by: Patrik Jakobsson <patrik.r.jakobsson@gmail.com>
> 
> What platform is this - I'd really like to keep such things automatic and
> also if possible make the code handle the case not blow up. The user
> shouldn't have to deal with such funnies.

I agree, there should be a way to automatically detect this, we don't
need another-module-parameter for something like this if at all
possible.

thanks,

greg k-h
