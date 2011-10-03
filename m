Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932543Ab1JCSww (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Oct 2011 14:52:52 -0400
Received: from cantor2.suse.de ([195.135.220.15]:42642 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932513Ab1JCSwq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Oct 2011 14:52:46 -0400
Date: Mon, 3 Oct 2011 11:38:06 -0700
From: Greg KH <gregkh@suse.de>
To: Bjorn Helgaas <bhelgaas@google.com>
Cc: linux-kernel@vger.kernel.org, stable@kernel.org, stable-review@kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Jon Mason <mason@myri.com>,
        Jesse Barnes <jbarnes@virtuousgeek.org>,
        Ben Hutchings <bhutchings@solarflare.com>
Subject: Re: [099/244] PCI: Set PCI-E Max Payload Size on fabric
Message-ID: <20111003183806.GA22292@suse.de>
References: <20110928220225.GA27128@kroah.com>
 <20110928220135.776796691@clark.kroah.org>
 <CAErSpo5ynWTUNSY7NuXC-bRx5ZT0J-Ya5iTg=MBCSH37PYMS+A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAErSpo5ynWTUNSY7NuXC-bRx5ZT0J-Ya5iTg=MBCSH37PYMS+A@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 30, 2011 at 04:33:29PM -0600, Bjorn Helgaas wrote:
> On Wed, Sep 28, 2011 at 4:01 PM, Greg KH <gregkh@suse.de> wrote:
> > 3.0-stable review patch.  If anyone has any objections, please let us know.
> 
> I object to this :)  I think the following patches should be omitted
> from -stable:
> 
> [099/244] PCI: Set PCI-E Max Payload Size on fabric
> [100/244] PCI: export pcie_bus_configure_settings symbol
> [101/244] PCI: Remove MRRS modification from MPS setting code
> [212/244] pci: Dont crash when reading mpss from root complex
> 
> I've heard rumors that these patches are required to make 3.0 boot on
> some machines, but I don't really believe it, and I haven't seen the
> problem reports myself.

Ok, I've removed these from the 3.0.5 release, but I really want them in
a future 3.0-stable release, so I'll carry them over to the next one and
keep trying until it all gets worked out.

As for the bug reports, I've seen them, but I don't know the status of
the hardware to be able to have them reported publicly at the moment,
sorry.

> Also, these patches introduce an open regression (Avi's e1000e
> problem).  Jon has mooted a patch that we hope will fix the
> regression, but I'm still not confident that this is all safe for 3.1,
> much less 3.0-stable.

I'll keep working with Jon on these.

thanks,

greg k-h
