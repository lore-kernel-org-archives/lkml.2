Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754738Ab1AFD1M (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Jan 2011 22:27:12 -0500
Received: from cantor.suse.de ([195.135.220.2]:56264 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753416Ab1AFD1K (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Jan 2011 22:27:10 -0500
Date: Wed, 5 Jan 2011 19:19:50 -0800
From: Greg KH <gregkh@suse.de>
To: "Gorby, Russ" <russ.gorby@intel.com>
Cc: "segoon@openwall.com" <segoon@openwall.com>,
        "alan@linux.intel.com" <alan@linux.intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Ahmed, Suhail" <suhail.ahmed@intel.com>
Subject: Re: [PATCH 0/7] IFX6X60 patchset: 01/05/2011
Message-ID: <20110106031950.GA19194@suse.de>
References: <1294272313-15899-1-git-send-email-russ.gorby@intel.com>
 <20110106001452.GA10637@suse.de>
 <4C5E6457CD7911469A07260381288C28CB7DF6EA@orsmsx502.amr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4C5E6457CD7911469A07260381288C28CB7DF6EA@orsmsx502.amr.corp.intel.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 05, 2011 at 04:33:39PM -0800, Gorby, Russ wrote:
> 
> 
> >-----Original Message-----
> >
> >On Wed, Jan 05, 2011 at 04:05:06PM -0800, Russ Gorby wrote:
> >> Hello SPI/Serial Maintainers,
> >
> >Um, you really got the cc: list wrong, please fix that next time.
> >
> [Gorby, Russ] sorry, get_maintainers.pl output was not properly consumed by my script and got some additional garbage addresses

That's some wierd email quoting, please fix your email client (i.e. use
a sane one.)

> >It's too late now, sorry.  We are in the middle of the big merge window
> >for .38-rc1 (which means your patches needed to be in a maintainer's
> >tree a few weeks ago).  I'll consider these after that comes out.
> >
> 
> [Gorby, Russ] fair enough - do you want me to resubmit the patchset later on or will you cache it and take it up later?

Please send it again, as it isn't correct as pointed out by Alan :)

thanks,

greg k-h
