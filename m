Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754380Ab1EFHl1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 May 2011 03:41:27 -0400
Received: from mail.skyhub.de ([78.46.96.112]:43519 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754282Ab1EFHlZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 May 2011 03:41:25 -0400
Date: Fri, 6 May 2011 09:41:20 +0200
From: Borislav Petkov <bp@alien8.de>
To: Ben Hutchings <ben@decadent.org.uk>
Cc: Greg KH <gregkh@suse.de>, Hans Rosenfeld <hans.rosenfeld@amd.com>,
        linux-kernel@vger.kernel.org, stable@kernel.org,
        akpm@linux-foundation.org, "H. Peter Anvin" <hpa@linux.intel.com>,
        torvalds@linux-foundation.org, stable-review@kernel.org,
        alan@lxorguk.ukuu.org.uk, bp@amd64.org
Subject: Re: [Stable-review] [12/28] x86, cpu: Clean up AMD erratum 400
 workaround
Message-ID: <20110506074120.GB21046@liondog.tnic>
Mail-Followup-To: Borislav Petkov <bp@alien8.de>,
	Ben Hutchings <ben@decadent.org.uk>, Greg KH <gregkh@suse.de>,
	Hans Rosenfeld <hans.rosenfeld@amd.com>,
	linux-kernel@vger.kernel.org, stable@kernel.org,
	akpm@linux-foundation.org, "H. Peter Anvin" <hpa@linux.intel.com>,
	torvalds@linux-foundation.org, stable-review@kernel.org,
	alan@lxorguk.ukuu.org.uk, bp@amd64.org
References: <20110419204117.979118654@clark.kroah.org>
 <1303263653.3464.65.camel@localhost>
 <20110420020128.GA27631@suse.de>
 <1303265862.3464.77.camel@localhost>
 <20110420031105.GA11945@suse.de>
 <1303274910.3464.95.camel@localhost>
 <20110420050617.GA16756@suse.de>
 <1303356555.3464.128.camel@localhost>
 <20110505225302.GC12316@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20110505225302.GC12316@suse.de>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hey Ben,

On Thu, May 05, 2011 at 03:53:02PM -0700, Greg KH wrote:
> On Thu, Apr 21, 2011 at 04:29:15AM +0100, Ben Hutchings wrote:
> > > We got a few new quirks added for AMD hardware platforms that fix
> > > problems.
> > 
> > Maybe, but I still haven't seen anyone explain what those problems are!
> 
> I'll let the AMD people answer this.

it's hard to follow back in this thread to what exactly you'd like to
have answered. Can you please repeat your questions concerning the AMD
backports? Is it, per chance, about Erratum 400 CPU f/m/s ranges that
got changed?

Thanks.

-- 
Regards/Gruss,
    Boris.
