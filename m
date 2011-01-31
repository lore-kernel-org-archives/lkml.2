Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756350Ab1AaVBg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Jan 2011 16:01:36 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:44577 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754062Ab1AaVBf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Jan 2011 16:01:35 -0500
Date: Mon, 31 Jan 2011 14:01:31 -0700
From: Grant Likely <grant.likely@secretlab.ca>
To: Sam Ravnborg <sam@ravnborg.org>
Cc: devicetree-discuss@lists.ozlabs.org, linuxppc-dev@lists.ozlabs.org,
        linux-kernel@vger.kernel.org, jwboyer@linux.vnet.ibm.com,
        benh@kernel.crashing.org
Subject: Re: [PATCH 0/3] dt: documentation reorganization
Message-ID: <20110131210131.GA14086@angua.secretlab.ca>
References: <20110131073918.9058.37628.stgit@localhost6.localdomain6>
 <20110131203449.GA4199@merkur.ravnborg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110131203449.GA4199@merkur.ravnborg.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 31, 2011 at 09:34:49PM +0100, Sam Ravnborg wrote:
> On Mon, Jan 31, 2011 at 12:44:41AM -0700, Grant Likely wrote:
> > This series reorganizes and cleans up the device tree documentation
> > to make the directory useful for non-powerpc users.
> 
> Looks better than first try. But the structure is very flat.
> Did you consider an arch/* for all arch specific stuff?

Yes I did; but this stuff is pretty sparse so I didn't want to create
a whole lot of levels when it isn't warranted.  If really required in
the future I'll split the arch and drivers into two separate
directories.  In the mean time I'm going to stick with this.

g.

