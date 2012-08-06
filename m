Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756134Ab2HFNts (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Aug 2012 09:49:48 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:50847 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754867Ab2HFNtq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Aug 2012 09:49:46 -0400
Date: Mon, 6 Aug 2012 08:49:33 -0500
From: Seth Forshee <seth.forshee@canonical.com>
To: Francois Rigaut <frigaut@mso.anu.edu.au>
Cc: Greg KH <gregkh@linuxfoundation.org>,
        Matthew Garrett <mjg59@srcf.ucam.org>, matt.fleming@intel.com,
        bhelgaas@google.com, linux-efi@vger.kernel.org,
        linux-kernel@vger.kernel.org, x86@kernel.org,
        linux-pci@vger.kernel.org
Subject: Re: [PATCH V2 1/4] EFI: Stash ROMs if they're not in the PCI BAR
Message-ID: <20120806134933.GA28213@thinkpad-t410>
Mail-Followup-To: Francois Rigaut <frigaut@mso.anu.edu.au>,
	Greg KH <gregkh@linuxfoundation.org>,
	Matthew Garrett <mjg59@srcf.ucam.org>, matt.fleming@intel.com,
	bhelgaas@google.com, linux-efi@vger.kernel.org,
	linux-kernel@vger.kernel.org, x86@kernel.org,
	linux-pci@vger.kernel.org
References: <501A955D.6030500@mso.anu.edu.au>
 <20120802161209.GF32395@thinkpad-t410>
 <501B01ED.9080309@mso.anu.edu.au>
 <501B0536.6070001@mso.anu.edu.au>
 <20120803045312.GB2446@thinkpad-t410>
 <501BD1FC.9020601@mso.anu.edu.au>
 <20120803141421.GA8165@thinkpad-t410>
 <501C7C1D.5010903@mso.anu.edu.au>
 <20120804035844.GA31711@thinkpad-t410>
 <501CB6AE.3000400@mso.anu.edu.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <501CB6AE.3000400@mso.anu.edu.au>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Aug 04, 2012 at 03:44:14PM +1000, Francois Rigaut wrote:
> Seth,
> 
> [CC'd people, sorry we exchanged a few emails with Seth outside of
> the lists, I passed him the acpi tables and here are gmux dumps]
> 
> Allright. thanks for gmux-dump. There seems to be progress, as I can
> see the gmux dumps for the nividia-selected and intel-selected are
> clearly different (I did it twice to be sure, it checks out).
> The 2 dumps are at
> http://maumae.net/retina/gmux-dump_intel.dat
> and
> http://maumae.net/retina/gmux-dump_nvidia_only.dat
> I hope you'll be able to get something from these.

It looks like you're not really getting data from the gmux in those
dumps. The address range should be correct based on your ACPI tables. I
have some ideas, but it won't be much longer until I can play with one
of these machines myself so it's probably easier if I try them out then.

Thanks,
Seth

