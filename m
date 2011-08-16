Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753294Ab1HPBYR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Aug 2011 21:24:17 -0400
Received: from cantor2.suse.de ([195.135.220.15]:34108 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752498Ab1HPBYQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Aug 2011 21:24:16 -0400
Date: Mon, 15 Aug 2011 18:24:03 -0700
From: Greg KH <gregkh@suse.de>
To: Dave Jones <davej@redhat.com>, Jiri Slaby <jirislaby@gmail.com>,
        linux-kernel@vger.kernel.org, stable@kernel.org,
        stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk
Subject: Re: [00/90] 3.0.2-stable review
Message-ID: <20110816012403.GB22104@suse.de>
References: <20110812210626.GA4725@kroah.com>
 <4E47A400.1030607@gmail.com>
 <20110814161842.GA7864@suse.de>
 <20110815205653.GA13895@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110815205653.GA13895@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 15, 2011 at 04:56:53PM -0400, Dave Jones wrote:
> On Sun, Aug 14, 2011 at 09:18:42AM -0700, Greg KH wrote:
>  > On Sun, Aug 14, 2011 at 12:31:28PM +0200, Jiri Slaby wrote:
>  > > On 08/12/2011 11:06 PM, Greg KH wrote:
>  > > > This is the start of the stable review cycle for the 3.0.2 release.
>  > > > There are 90 patches in this series, all will be posted as a response
>  > > > to this one.
>  > > 
>  > > It looks like they didn't go through to LKML. Neither for 3.0.2, nor for
>  > > .32.45, nor for .33.18. Could you resend?
>  > 
>  > Sorry, none of them got sent, that was my fault.  I've now sent them
>  > all.
> 
> Seems to be missing aba8d056078e47350d85b06a9cabd5afcc4b72ea
> which is CVE-2011-2905

It would have been nice if someone had sent that patch to
stable@kernel.org :(

I'll queue it up for the next release after this one, thanks.

greg k-h
