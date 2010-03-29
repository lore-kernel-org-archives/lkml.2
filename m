Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754833Ab0C2WVd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Mar 2010 18:21:33 -0400
Received: from mail-bw0-f209.google.com ([209.85.218.209]:55881 "EHLO
	mail-bw0-f209.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753881Ab0C2WVa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Mar 2010 18:21:30 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=u2JwZ0Q4s2OW+l/a/Dz9xwyYsmzvNM5GdvRh8IWJpPcHhVG2wriL1VktHWMmhGLH3F
         EyAMVJfJTPRMrp3JKS/0I4/79AI4L664O4Me9lHcFPdck1txCVclArbSGdM9/AGtQXSM
         4lGPlxkf+VlP8jw4qj8R26qJq0D8sj10SUNcU=
Date: Tue, 30 Mar 2010 00:21:34 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: David Miller <davem@davemloft.net>
Cc: linux-kernel@vger.kernel.org, sparclinux@vger.kernel.org
Subject: Re: [BUG] fault while using perf callchains in sparc64
Message-ID: <20100329222132.GB12254@nowhere>
References: <20100329211149.GK5101@nowhere> <20100329.141920.243015356.davem@davemloft.net> <20100329212839.GA12254@nowhere> <20100329.150253.11262563.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100329.150253.11262563.davem@davemloft.net>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 29, 2010 at 03:02:53PM -0700, David Miller wrote:
> From: Frederic Weisbecker <fweisbec@gmail.com>
> Date: Mon, 29 Mar 2010 23:28:42 +0200
> 
> > It's a Niagara 2 based one.
> 
> Strange, that's what I do all of my main sparc64 kernel
> work on too.  I've never seen these spurious 'as' crashes.
> 
> Hmmmm, what does "ldd /usr/bin/as" give you?
> 
> Thanks.


$ ldd /usr/bin/as
	libopcodes-2.18.0.20080103.so => /usr/lib/libopcodes-2.18.0.20080103.so (0xf7ec4000)
	libbfd-2.18.0.20080103.so => /usr/lib/libbfd-2.18.0.20080103.so (0xf7e14000)
	libc.so.6 => /lib/libc.so.6 (0xf7ca0000)
	/lib/ld-linux.so.2 (0xf7efc000)

The last kernel I know that don't have such problems is 2.6.31-rc6
May be I should bisect?

