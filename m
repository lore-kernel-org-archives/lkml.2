Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756710Ab2IODNp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Sep 2012 23:13:45 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:64718 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756016Ab2IODNS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Sep 2012 23:13:18 -0400
Date: Fri, 14 Sep 2012 20:13:13 -0700
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Ben Hutchings <ben@decadent.org.uk>
Cc: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Alex Deucher <alexander.deucher@amd.com>
Subject: Re: [ 24/46] ACPI: export symbol acpi_get_table_with_size
Message-ID: <20120915031313.GC25762@kroah.com>
References: <20120912233817.662663809@linuxfoundation.org>
 <20120912233820.189480865@linuxfoundation.org>
 <1347668540.13258.87.camel@deadeye.wl.decadent.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1347668540.13258.87.camel@deadeye.wl.decadent.org.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Sep 15, 2012 at 01:22:20AM +0100, Ben Hutchings wrote:
> On Wed, 2012-09-12 at 16:39 -0700, Greg Kroah-Hartman wrote:
> > From: Greg KH <gregkh@linuxfoundation.org>
> > 
> > 3.0-stable review patch.  If anyone has any objections, please let me know.
> > 
> > ------------------
> > 
> > From: Alex Deucher <alexander.deucher@amd.com>
> > 
> > commit 4f81f986761a7663db7d24d24cd6ae68008f1fc2 upstream.
> > 
> > We need it in the radeon drm module to fetch
> > and verify the vbios image on UEFI systems.
> 
> Unless you're planning going to include those radeon changes in the next
> update, I don't see the point of this.

Yes, they will be coming, I have a ton of drm patches to pick through
that I haven't gotten to.  This was just part of it, the rest will be in
the next release.

thanks,

greg k-h
