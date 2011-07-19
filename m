Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752114Ab1GSXdb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Jul 2011 19:33:31 -0400
Received: from cantor2.suse.de ([195.135.220.15]:50765 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751622Ab1GSXda (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Jul 2011 19:33:30 -0400
Date: Wed, 20 Jul 2011 01:33:27 +0200
From: Michal Marek <mmarek@suse.cz>
To: Randy Dunlap <rdunlap@xenotime.net>
Cc: Peter Foley <pefoley2@verizon.net>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] kernel: prevent unnecessary rebuilding due to
 config_data.gz
Message-ID: <20110719233327.GB4482@sepie.suse.cz>
References: <alpine.LNX.2.00.1107051741390.20637@linux>
 <20110706083329.9755dc70.rdunlap@xenotime.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110706083329.9755dc70.rdunlap@xenotime.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 06, 2011 at 08:33:29AM -0700, Randy Dunlap wrote:
> On Tue, 05 Jul 2011 19:42:18 -0400 (EDT) Peter Foley wrote:
> 
> > When IKCONFIG is built-in make oldconfig will cause the kernel to be 
> > relinked even if .config didn't change. This happens because of a 
> > config_data.gz dependency on .config. This patch changes the if_changed to 
> > a filechk so that config_data.h is only rebuilt when the contents 
> > have actually changed.
> > 
> > Signed-off-by: Peter Foley <pefoley2@verizon.net>
> 
> Michal,
> If this looks OK to you, please merge it.

Thanks, merged to kbuild-2.6.git#kbuild.

Michal
