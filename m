Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933427Ab0HDTqe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Aug 2010 15:46:34 -0400
Received: from cantor.suse.de ([195.135.220.2]:37986 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758665Ab0HDTqa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Aug 2010 15:46:30 -0400
Date: Wed, 4 Aug 2010 12:44:41 -0700
From: Greg KH <gregkh@suse.de>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        David Airlie <airlied@linux.ie>, David Miller <davem@davemloft.net>,
        Fenghua Yu <fenghua.yu@intel.com>,
        Jason Wessel <jason.wessel@windriver.com>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Russell King <linux@arm.linux.org.uk>, Tony Luck <tony.luck@intel.com>
Subject: Re: [PATCH 0/3] SysRq: do not pass tty argument around
Message-ID: <20100804194441.GB30722@suse.de>
References: <20100804075602.30647.91462.stgit@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100804075602.30647.91462.stgit@localhost.localdomain>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 04, 2010 at 12:58:55AM -0700, Dmitry Torokhov wrote:
> Hi,
> 
> The following 3 patches get rid of 'tty' argument in SysRq handlers as
> nobody is using it. If noone objects I'd like to get it merged through
> my tree.

Nice job.

No objection from me for you to take this through your tree:
	Acked-by: Greg Kroah-Hartman <gregkh@suse.de>

thanks,

greg k-h
