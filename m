Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757337Ab2HVIue (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Aug 2012 04:50:34 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:34500 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752062Ab2HVIuW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Aug 2012 04:50:22 -0400
Date: Wed, 22 Aug 2012 09:50:17 +0100
From: Andy Whitcroft <apw@canonical.com>
To: Olaf Hering <olaf@aepfle.de>
Cc: Ben Hutchings <ben@decadent.org.uk>, Greg KH <gregkh@linuxfoundation.org>,
        "K. Y. Srinivasan" <kys@microsoft.com>, linux-kernel@vger.kernel.org,
        devel@linuxdriverproject.org
Subject: Re: [PATCH V3 08/14] Tools: hv: Gather DNS information
Message-ID: <20120822085017.GX29100@dm>
References: <1345167068-5461-1-git-send-email-kys@microsoft.com>
 <1345167145-5513-1-git-send-email-kys@microsoft.com>
 <1345167145-5513-8-git-send-email-kys@microsoft.com>
 <20120817165109.GA11323@kroah.com>
 <20120817173209.GA29217@decadent.org.uk>
 <20120817182721.GA7747@aepfle.de>
 <20120817184421.GD29217@decadent.org.uk>
 <20120817185353.GA14154@aepfle.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120817185353.GA14154@aepfle.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 17, 2012 at 08:53:53PM +0200, Olaf Hering wrote:
> On Fri, Aug 17, Ben Hutchings wrote:
> 
> > You are never going to have a 'works everywhere' solution for
> > Linux guests.
> 
> The hook is the solution.
> 
> > How are these distribution-specific integration scripts going
> > to get installed in the guesta, anyway?
> 
> The packager of the daemon will write the script, perhaps based on a
> template included in tools/hv/script_xyz.sh?

This seems a reasonable approach and one with precident.  We use a similar
scheme for how to handle 'make install' in the kernel letting the distro
provide /sbin/installkernel so as to avoid having distro smarts for every
distro in the kernel source.

It might be nice to share some examples if you have them, but it feels a
little grubby to have them in the kernel tree.

-apw
