Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752650Ab1BPQC4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Feb 2011 11:02:56 -0500
Received: from cantor2.suse.de ([195.135.220.15]:35769 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751395Ab1BPQCy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Feb 2011 11:02:54 -0500
Date: Wed, 16 Feb 2011 07:59:01 -0800
From: Greg KH <gregkh@suse.de>
To: Nick Bowler <nbowler@elliptictech.com>
Cc: linux-kernel@vger.kernel.org, stable@kernel.org, stable-review@kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk
Subject: Re: [000/272] 2.6.37.1-stable review
Message-ID: <20110216155901.GG29006@suse.de>
References: <20110216001559.GA31413@kroah.com>
 <20110216143132.GA1928@elliptictech.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110216143132.GA1928@elliptictech.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 16, 2011 at 09:31:32AM -0500, Nick Bowler wrote:
> On 2011-02-15 16:15 -0800, Greg KH wrote:
> > Note, there are still some patches that people have sent me that did not
> > make it to this release.  They will show up in the next one, this one is
> > big enough, as I'm sure you will agree.
> 
> Hi Greg,
> 
> Commit c42988012ad9 ("drm/nouveau: Only select ACPI_VIDEO if its
> dependencies are met") is needed to fix a build failure on 2.6.37.
> 
> I don't see it in your list, and it seems like the patch wasn't Cc'd to
> stable, so I just want to make sure you know about it.

It wasn't in my list, and no one let me know about it.  I'll let it wait
for the .2 release, thanks.

greg k-h
