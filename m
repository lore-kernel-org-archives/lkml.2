Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754808Ab0H0AAh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Aug 2010 20:00:37 -0400
Received: from cantor2.suse.de ([195.135.220.15]:45875 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754660Ab0H0AAe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Aug 2010 20:00:34 -0400
Date: Thu, 26 Aug 2010 16:25:24 -0700
From: Greg KH <gregkh@suse.de>
To: Matt Evans <matt@ozlabs.org>
Cc: linux-kernel@vger.kernel.org, stable@kernel.org, stable-review@kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Michael Neuling <mikey@neuling.org>
Subject: Re: [49/59] powerpc: Initialise paca->kstack before
	early_setup_secondary
Message-ID: <20100826232524.GA12868@suse.de>
References: <20100824222526.676650737@clark.site> <4C761367.2000506@ozlabs.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4C761367.2000506@ozlabs.org>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 26, 2010 at 05:10:31PM +1000, Matt Evans wrote:
> Hi Greg,
> 
> On 25/08/10 08:25, Greg KH wrote:
> > 2.6.32-stable review patch.  If anyone has any objections, please let us know.
> 
> I have an objection!   We've found a problem, it breaks stuff fairly
> thoroughly.  >:(  Mikey has submitted
> http://patchwork.ozlabs.org/patch/62757/ to Ben's tree to fix it, but
> it might be easier all round to drop this and we can resubmit the
> indivisible pair of commits to -stable later?  (You'd selected this
> for {34,35}-stable also.)

I've now dropped it, please let me know when you want it back in, if at
all, in the future.

thanks,

greg k-h
