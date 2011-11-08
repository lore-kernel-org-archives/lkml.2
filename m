Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754751Ab1KHVxG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Nov 2011 16:53:06 -0500
Received: from out1.smtp.messagingengine.com ([66.111.4.25]:57493 "EHLO
	out1.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751514Ab1KHVxE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Nov 2011 16:53:04 -0500
X-Sasl-enc: mXUY1BZzi0XFXk5En0spxfEm/KBtsNDjdmX5rkdicTRQ 1320789182
Date: Tue, 8 Nov 2011 13:48:53 -0800
From: Greg KH <greg@kroah.com>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Staging clear up
Message-ID: <20111108214853.GB20279@kroah.com>
References: <20111108211656.29defdda@lxorguk.ukuu.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111108211656.29defdda@lxorguk.ukuu.org.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 08, 2011 at 09:16:56PM +0000, Alan Cox wrote:
> Moorestown/Oaktrail has appeared only in the PC like form so the
> following bits of staging can be binned
> 
> drivers/staging/spectra
> 
> (not needed)
> 
> drivers/staging/intel_sst
> 
> This also appears on Medfield but there is an ASoC driver for the
> Medfield version and we no longer need to keep this. There were naughty
> bits of code peeking into staging for files but that should now be sorted
> (and if not they need to break and be forced to fix them)
> 
> I can send patches but they are enormous and rather boring...

Ok, I'll go delete these two directories.  No reason it can't be done
for 3.2, or do you want me to wait until 3.3?

thanks,

greg k-h
