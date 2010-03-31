Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758212Ab0CaVLv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Mar 2010 17:11:51 -0400
Received: from cantor2.suse.de ([195.135.220.15]:46292 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758176Ab0CaVLt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Mar 2010 17:11:49 -0400
Date: Wed, 31 Mar 2010 14:11:46 -0700
From: Greg KH <gregkh@suse.de>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: linux-kernel@vger.kernel.org, stable@kernel.org, stable-review@kernel.org,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk, Clemens Ladisch <clemens@ladisch.de>,
       Jesse Barnes <jbarnes@virtuousgeek.org>
Subject: Re: [091/156] PCI quirk: RS780/RS880: work around missing MSI
	initialization
Message-ID: <20100331211146.GA19139@suse.de>
References: <20100330224821.025709984@linux.site> <201003312240.39444.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201003312240.39444.rjw@sisk.pl>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 31, 2010 at 10:40:39PM +0200, Rafael J. Wysocki wrote:
> On Wednesday 31 March 2010, Greg KH wrote:
> > 2.6.33-stable review patch.  If anyone has any objections, please let us know.
> 
> I do, this one causes a regression to happen on my test box.

Now dropped.

thanks,

greg k-h
