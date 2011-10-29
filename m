Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752977Ab1J2GfO (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 Oct 2011 02:35:14 -0400
Received: from cantor2.suse.de ([195.135.220.15]:58382 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750749Ab1J2GfM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 Oct 2011 02:35:12 -0400
Date: Sat, 29 Oct 2011 08:34:09 +0200
From: Greg KH <gregkh@suse.de>
To: KY Srinivasan <kys@microsoft.com>
Cc: Jiri Kosina <jkosina@suse.cz>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devel@linuxdriverproject.org" <devel@linuxdriverproject.org>,
        "virtualization@lists.osdl.org" <virtualization@lists.osdl.org>,
        "ohering@suse.com" <ohering@suse.com>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>
Subject: Re: [PATCH 1/1] Staging: hv: Move the mouse driver out of staging
Message-ID: <20111029063409.GB2207@suse.de>
References: <1319645321-9770-1-git-send-email-kys@microsoft.com>
 <alpine.LNX.2.00.1110282026360.3541@pobox.suse.cz>
 <6E21E5352C11B742B20C142EB499E0481AA531D4@TK5EX14MBXC122.redmond.corp.microsoft.com>
 <20111028200315.GA30918@suse.de>
 <6E21E5352C11B742B20C142EB499E0481AA53219@TK5EX14MBXC122.redmond.corp.microsoft.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6E21E5352C11B742B20C142EB499E0481AA53219@TK5EX14MBXC122.redmond.corp.microsoft.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 28, 2011 at 08:28:11PM +0000, KY Srinivasan wrote:
> > > The guest cannot survive a malicious host; so I think it is safe to say that the
> > > guest can assume the host is following the protocol.
> > 
> > That's not good for a very large number of reasons, not the least being
> > that we have no idea how secure the hyperv hypervisor is, so making it
> > so that there isn't an obvious hole into linux through it, would be a
> > good idea.
> > 
> > And yes, I'd say the same thing if this was a KVM or Xen driver as well.
> > Please be very defensive in this area of the code, especially as there
> > are no performance issues here.
> 
> In the chain of trust, the hypervisor and the host are the foundations
> as far as the guest is concerned, since both the hypervisor and the host
> can affect the guest in ways that the guest has no obvious way to protect itself.

That's true.

> If the hypervisor/host have security holes, there is not much you can do in the guest
> to deal with it. 
> In this case, I can add checks but I am not sure how useful it is.

I would prefer to see them here, just to be safe, it can not hurt,
right?


greg k-h
