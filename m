Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758340Ab2KBPww (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Nov 2012 11:52:52 -0400
Received: from mx1.redhat.com ([209.132.183.28]:24533 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754415Ab2KBPwu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Nov 2012 11:52:50 -0400
Date: Fri, 2 Nov 2012 11:52:47 -0400
From: Vivek Goyal <vgoyal@redhat.com>
To: Matthew Garrett <mjg@redhat.com>
Cc: Jiri Kosina <jkosina@suse.cz>, linux-kernel@vger.kernel.org,
        linux-security-module@vger.kernel.org, linux-efi@vger.kernel.org
Subject: Re: [RFC] Second attempt at kernel secure boot support
Message-ID: <20121102155247.GH3300@redhat.com>
References: <1348152065-31353-1-git-send-email-mjg@redhat.com>
 <alpine.LRH.2.00.1210290848450.10392@twin.jikos.cz>
 <20121029174131.GC7580@srcf.ucam.org>
 <alpine.LNX.2.00.1210311444080.12781@pobox.suse.cz>
 <20121031150201.GA12394@srcf.ucam.org>
 <20121102153047.GF3300@redhat.com>
 <20121102154248.GA7681@srcf.ucam.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121102154248.GA7681@srcf.ucam.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 02, 2012 at 03:42:48PM +0000, Matthew Garrett wrote:
> On Fri, Nov 02, 2012 at 11:30:48AM -0400, Vivek Goyal wrote:
> 
> > "crash" utility has module which allows reading kernel memory. So leaking
> > this private key will be easier then you are thinking it to be.
> 
> That's not upstream, right?

Yes, checked with Dave, it is not upstream. Well, still it is a concern
for distro kernel.

So if we keep private key in kernel, looks like we shall have to disable
one more feature in secureboot mode.

Thanks
Vivek
