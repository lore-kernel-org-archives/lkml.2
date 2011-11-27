Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752604Ab1K0JrA (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Nov 2011 04:47:00 -0500
Received: from out2.smtp.messagingengine.com ([66.111.4.26]:60880 "EHLO
	out2.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751241Ab1K0Jq7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Nov 2011 04:46:59 -0500
X-Sasl-enc: LK3fu34968a6La2qUocMWoAv2fEt8YnLQD5ukbLxWvWn 1322387217
Date: Sat, 26 Nov 2011 17:30:48 -0800
From: Greg KH <greg@kroah.com>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Staging clear up
Message-ID: <20111127013048.GA21222@kroah.com>
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
> 
> I will be sending patches for other bits like the battery manager which
> in actual product is always ACPI handled.

Ok, I've deleted the spectra driver for the 3.3 merge window, if you
still want me to delete the intel_sst driver, please let me know (based
on the email thread, I got the impression you didn't want me to.)

thanks,

greg k-h
