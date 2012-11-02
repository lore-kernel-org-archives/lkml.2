Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759895Ab2KBQWt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Nov 2012 12:22:49 -0400
Received: from cantor2.suse.de ([195.135.220.15]:36045 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759649Ab2KBQWp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Nov 2012 12:22:45 -0400
Date: Fri, 2 Nov 2012 17:22:41 +0100 (CET)
From: Jiri Kosina <jkosina@suse.cz>
To: Vivek Goyal <vgoyal@redhat.com>
Cc: Matthew Garrett <mjg@redhat.com>, linux-kernel@vger.kernel.org,
        linux-security-module@vger.kernel.org, linux-efi@vger.kernel.org
Subject: Re: [RFC] Second attempt at kernel secure boot support
In-Reply-To: <20121102155247.GH3300@redhat.com>
Message-ID: <alpine.LNX.2.00.1211021722140.24253@pobox.suse.cz>
References: <1348152065-31353-1-git-send-email-mjg@redhat.com> <alpine.LRH.2.00.1210290848450.10392@twin.jikos.cz> <20121029174131.GC7580@srcf.ucam.org> <alpine.LNX.2.00.1210311444080.12781@pobox.suse.cz> <20121031150201.GA12394@srcf.ucam.org>
 <20121102153047.GF3300@redhat.com> <20121102154248.GA7681@srcf.ucam.org> <20121102155247.GH3300@redhat.com>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2 Nov 2012, Vivek Goyal wrote:

> > > "crash" utility has module which allows reading kernel memory. So leaking
> > > this private key will be easier then you are thinking it to be.
> > 
> > That's not upstream, right?
> 
> Yes, checked with Dave, it is not upstream. Well, still it is a concern
> for distro kernel.

Well, that's about /dev/crash, right?

How about /proc/kcore?

-- 
Jiri Kosina
SUSE Labs
