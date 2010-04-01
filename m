Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932248Ab0DAQ7Q (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Apr 2010 12:59:16 -0400
Received: from buzzloop.caiaq.de ([212.112.241.133]:35572 "EHLO
	buzzloop.caiaq.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758079Ab0DAQ7E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Apr 2010 12:59:04 -0400
Date: Thu, 1 Apr 2010 18:58:57 +0200
From: Daniel Mack <daniel@caiaq.de>
To: Greg KH <gregkh@suse.de>
Cc: LKML <linux-kernel@vger.kernel.org>,
       AKML <linux-arm-kernel@lists.infradead.org>,
       linux-wireless@vger.kernel.org, Sven Neumann <s.neumann@raumfeld.com>
Subject: Re: Memory corruption with 2.6.32.10, but not with 2.6.34-rc3
Message-ID: <20100401165857.GN30801@buzzloop.caiaq.de>
References: <20100401132156.GJ30807@buzzloop.caiaq.de>
 <20100401165144.GB1138@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100401165144.GB1138@suse.de>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 01, 2010 at 09:51:44AM -0700, Greg KH wrote:
> On Thu, Apr 01, 2010 at 03:21:56PM +0200, Daniel Mack wrote:
> > 
> > I can cherry-pick things if anyone pin-points something and run
> > lont-time tests again. Any pointer appreciated.
> 
> Oh, how about running 'git bisect' to try to find the solution?  Just
> remember to reverse 'good' and 'bad' for when you tell git bisect what
> the results are.

Jep, I thought about that of course. But unfortunately, the platform
got merged mainline in the middle of that time window which makes
bisecting tricky. And worse than that - every test run take around half
a day at least :(

Daniel
