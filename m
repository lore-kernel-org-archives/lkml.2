Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751463Ab2HCEx0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Aug 2012 00:53:26 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:40406 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750744Ab2HCExY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Aug 2012 00:53:24 -0400
Date: Thu, 2 Aug 2012 23:53:12 -0500
From: Seth Forshee <seth.forshee@canonical.com>
To: Francois Rigaut <frigaut@mso.anu.edu.au>
Cc: Greg KH <gregkh@linuxfoundation.org>,
        Matthew Garrett <mjg59@srcf.ucam.org>, matt.fleming@intel.com,
        linux-efi@vger.kernel.org, linux-kernel@vger.kernel.org,
        x86@kernel.org, linux-pci@vger.kernel.org, bhelgaas@google.com
Subject: Re: [PATCH V2 1/4] EFI: Stash ROMs if they're not in the PCI BAR
Message-ID: <20120803045312.GB2446@thinkpad-t410>
Mail-Followup-To: Francois Rigaut <frigaut@mso.anu.edu.au>,
	Greg KH <gregkh@linuxfoundation.org>,
	Matthew Garrett <mjg59@srcf.ucam.org>, matt.fleming@intel.com,
	linux-efi@vger.kernel.org, linux-kernel@vger.kernel.org,
	x86@kernel.org, linux-pci@vger.kernel.org, bhelgaas@google.com
References: <1343407934-459-1-git-send-email-mjg@redhat.com>
 <20120731223240.GD19134@kroah.com>
 <20120801165400.GA3042@srcf.ucam.org>
 <20120801232147.GA6228@kroah.com>
 <20120802040242.GB25933@thinkpad-t410>
 <20120802103423.GA1921@kroah.com>
 <501A955D.6030500@mso.anu.edu.au>
 <20120802161209.GF32395@thinkpad-t410>
 <501B01ED.9080309@mso.anu.edu.au>
 <501B0536.6070001@mso.anu.edu.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <501B0536.6070001@mso.anu.edu.au>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 03, 2012 at 08:54:46AM +1000, Francois Rigaut wrote:
> Seth,
> 
> I have put the osx system.log, which is the only file where I can
> see mux and AGC related message, at
> http://maumae.net/retina/system.log

That does seem to contain the kernel log messages, but unfortunately I'm
not seeing what I'm looking for there.

> Thanks,
> Francois
> 
> On 03/08/12 08:40, Francois Rigaut wrote:
> >Hi Seth,
> >
> >Sorry for the belated response. On Oz time here.
> >I don't have a /var/log/kernel.log !
> >Let me make sure of something:
> >This switcher code is to be run on osx, no? That's where
> >gfxcardstatus lives and where I can effect the card switch. Just
> >to make sure.
> >So I'm running osx mountain lion, and the only thing I see in the
> >logs when I switch cards (using gfxcardstatus) is what I pasted
> >below. and you're right, it was not in message.log, but system.log
> >(it was late). I just went through the whole thing again.
> >Am I missing something?

Yes, it's to be run on OS X. So apparently something has changed and
this technique no longer works for getting a log of the gmux I/O.

We've got one of these machines on order, so I'll see if I can turn
anything up when I get a chance to play with it.

Thanks,
Seth

