Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752675Ab2KEMJw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Nov 2012 07:09:52 -0500
Received: from arkanian.console-pimps.org ([212.110.184.194]:56811 "EHLO
	arkanian.console-pimps.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752521Ab2KEMJt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Nov 2012 07:09:49 -0500
Message-ID: <1352117386.14888.276.camel@mfleming-mobl1.ger.corp.intel.com>
Subject: Re: [PATCH] samsung-laptop: Disable if CONFIG_EFI=y
From: Matt Fleming <matt@console-pimps.org>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Greg KH <gregkh@linuxfoundation.org>,
        Corentin Chary <corentincj@iksaif.net>,
        Matthew Garrett <mjg@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
        linux-efi@vger.kernel.org,
        "platform-driver-x86@vger.kernel.org" 
	<platform-driver-x86@vger.kernel.org>,
        Alessandro Crismani <alessandro.crismani@gmail.com>,
        Mikhail Bakhterev <mike.bakhterev@gmail.com>,
        Patrick H <kernel@feystorm.net>, "H. Peter Anvin" <hpa@zytor.com>,
        stable@vger.kernel.org
Date: Mon, 05 Nov 2012 12:09:46 +0000
In-Reply-To: <20121105120736.33af173b@pyramind.ukuu.org.uk>
References: <1352050506-29317-1-git-send-email-matt@console-pimps.org>
	 <CAHR064isMXk8qkqhBJ==9sRRP7xC_j_K5rqXApza-LNkosp5mg@mail.gmail.com>
	 <20121104193741.7b4ca37b@pyramind.ukuu.org.uk>
	 <CAHR064jwe=diZ9B-D+-SroCW1ZevkRDMosB7uDuc2VXZkFxmdA@mail.gmail.com>
	 <20121105103031.GA25659@kroah.com>
	 <1352116219.14888.262.camel@mfleming-mobl1.ger.corp.intel.com>
	 <20121105120736.33af173b@pyramind.ukuu.org.uk>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4 (3.4.4-2.fc17) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2012-11-05 at 12:07 +0000, Alan Cox wrote:
> > There is the 'efi_enabled' variable, but it doesn't strictly mean
> > "this_is_a_uefi_system()", it actually means "Do we have EFI runtime
> > services?". The whole thing is a bit of a mess and I'm planning on
> > cleaning it up this week.
> 
> 
> As far as I can understand it we should be reserving those areas on a
> UEFI booted machine and just marking them as busy so that they are not
> available to any drivers to go peering into.

Yes, that would be the best way to resolve this going forward.

-- 
Matt Fleming, Intel Open Source Technology Center

