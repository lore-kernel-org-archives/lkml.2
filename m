Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755996Ab2HTP5t (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Aug 2012 11:57:49 -0400
Received: from cavan.codon.org.uk ([93.93.128.6]:57459 "EHLO
	cavan.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753165Ab2HTP5p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Aug 2012 11:57:45 -0400
Date: Mon, 20 Aug 2012 16:57:41 +0100
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: Dave Airlie <airlied@gmail.com>, Daniel Vetter <daniel@ffwll.ch>,
        David Airlie <airlied@linux.ie>, dri-devel@lists.freedesktop.org,
        linux-kernel@vger.kernel.org, Andreas Heider <andreas@meetr.de>
Subject: Re: [RFC PATCH 7/7] drm/pci: Defer initialization of secondary
 graphics devices until switcheroo is ready
Message-ID: <20120820155740.GA30611@srcf.ucam.org>
References: <20120806045150.GA23652@thinkpad-t410>
 <1345476664-22066-1-git-send-email-seth.forshee@canonical.com>
 <1345476664-22066-8-git-send-email-seth.forshee@canonical.com>
 <20120820153640.GA29614@srcf.ucam.org>
 <20120820155633.GF11013@thinkpad-t410>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120820155633.GF11013@thinkpad-t410>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@cavan.codon.org.uk
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 20, 2012 at 10:56:33AM -0500, Seth Forshee wrote:
> On Mon, Aug 20, 2012 at 04:36:40PM +0100, Matthew Garrett wrote:
> > Won't this break the multiple cards with independent outputs case?
> 
> Yes, if they don't have a switcheroo handler. I only have experience
> with one such machine, which had optimus graphics. My recollection is
> that it did have a switcheroo handler, which was only capable of
> controlling power to the discrete card.

So if I have a desktop machine and install two graphics cards?

-- 
Matthew Garrett | mjg59@srcf.ucam.org
