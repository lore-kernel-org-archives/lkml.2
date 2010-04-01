Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755759Ab0DAQwk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Apr 2010 12:52:40 -0400
Received: from cantor.suse.de ([195.135.220.2]:55946 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755223Ab0DAQwa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Apr 2010 12:52:30 -0400
Date: Thu, 1 Apr 2010 09:51:44 -0700
From: Greg KH <gregkh@suse.de>
To: Daniel Mack <daniel@caiaq.de>
Cc: LKML <linux-kernel@vger.kernel.org>,
       AKML <linux-arm-kernel@lists.infradead.org>,
       linux-wireless@vger.kernel.org, Sven Neumann <s.neumann@raumfeld.com>
Subject: Re: Memory corruption with 2.6.32.10, but not with 2.6.34-rc3
Message-ID: <20100401165144.GB1138@suse.de>
References: <20100401132156.GJ30807@buzzloop.caiaq.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100401132156.GJ30807@buzzloop.caiaq.de>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 01, 2010 at 03:21:56PM +0200, Daniel Mack wrote:
> 
> I can cherry-pick things if anyone pin-points something and run
> lont-time tests again. Any pointer appreciated.

Oh, how about running 'git bisect' to try to find the solution?  Just
remember to reverse 'good' and 'bad' for when you tell git bisect what
the results are.

thanks,

greg k-h
