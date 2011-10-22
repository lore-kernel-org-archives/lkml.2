Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754184Ab1JVQ7f (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Oct 2011 12:59:35 -0400
Received: from cantor2.suse.de ([195.135.220.15]:48869 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751249Ab1JVQ7e (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Oct 2011 12:59:34 -0400
Date: Sat, 22 Oct 2011 18:55:21 +0200
From: Greg KH <gregkh@suse.de>
To: Stefan Priebe <s.priebe@profihost.ag>
Cc: LKML <linux-kernel@vger.kernel.org>, Stable Tree <stable@kernel.org>
Subject: Re: Kernel hard LOCKUP with v3.0.7
Message-ID: <20111022165521.GA1716@suse.de>
References: <4EA1536E.6090001@profihost.ag>
 <20111021130752.GC8219@suse.de>
 <AA4CF3E1-3D52-418E-BED9-F34BD22168C3@profihost.ag>
 <20111021200257.GA31198@suse.de>
 <4EA2F2E0.4020702@profihost.ag>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4EA2F2E0.4020702@profihost.ag>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Oct 22, 2011 at 06:44:16PM +0200, Stefan Priebe wrote:
> Hi,
> 
> >Can you run 'git bisect' to try to find the problem patch?  Oh, there is
> >one bugfix that I know of, bcd5cff7216f9b2de0a148cc355eac199dc6f1cf in
> >Linus's tree, can you try that to see if it solves the problem for you?
> 
> this seems to fix it. Perhaps you should release v3.0.8 as the
> stable tree isn't stable right now? I mean this bug seems to be
> triggered on every SMP machine.

I will work to get it out soon.

thanks for testing and letting me know.

greg k-h
