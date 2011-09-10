Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933908Ab1IJSg1 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Sep 2011 14:36:27 -0400
Received: from cantor2.suse.de ([195.135.220.15]:37563 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933795Ab1IJSfz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Sep 2011 14:35:55 -0400
Date: Sat, 10 Sep 2011 20:35:46 +0200
From: Greg KH <gregkh@suse.de>
To: KY Srinivasan <kys@microsoft.com>
Cc: Greg KH <greg@kroah.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devel@linuxdriverproject.org" <devel@linuxdriverproject.org>,
        "virtualization@lists.osdl.org" <virtualization@lists.osdl.org>,
        Haiyang Zhang <haiyangz@microsoft.com>
Subject: Re: [PATCH 09/25] Staging: hv: util: Perform some service specific
 de-initialization in util_remove()
Message-ID: <20110910183546.GC30865@suse.de>
References: <1315491843-9513-1-git-send-email-kys@microsoft.com>
 <1315491876-9554-1-git-send-email-kys@microsoft.com>
 <1315491876-9554-9-git-send-email-kys@microsoft.com>
 <20110909204240.GF19127@kroah.com>
 <6E21E5352C11B742B20C142EB499E048081DC4C7@TK5EX14MBXC128.redmond.corp.microsoft.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6E21E5352C11B742B20C142EB499E048081DC4C7@TK5EX14MBXC128.redmond.corp.microsoft.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Sep 10, 2011 at 02:31:15PM +0000, KY Srinivasan wrote:
> I will rework this to be more on the lines of what you had suggested; and yes,
> I remember my original promise! I want to re-spin these patches and send it to 
> you as soon as possible. Which tree can I clone to get your latest check-ins; kernel.org
> still seems to have issues this morning. Have you checked in Olaf's patches.

I checked in one of Olaf's patches, but the others I told him needed to
be reworked to use KBUILD_MODNAME.

As for a public tree, no, sorry, my tree is not public until kernel.org
is back up and running, and I don't have any idea when that will be.

I'm out of the country all this week so responses from me is going to be
very delayed anyway.  Hopefully when I return kernel.org will be up and
running and everyone can sync up properly at that time.

greg k-h
