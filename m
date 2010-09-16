Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755866Ab0IPSpp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Sep 2010 14:45:45 -0400
Received: from kroah.org ([198.145.64.141]:48433 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754070Ab0IPSpo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Sep 2010 14:45:44 -0400
Date: Thu, 16 Sep 2010 11:44:46 -0700
From: Greg KH <greg@kroah.com>
To: Alan Cox <alan@linux.intel.com>
Cc: linux-serial@vger.kernel.org, linux-kernel@vger.kernel.org,
        drosenberg@vsecurity.com
Subject: Re: [PATCH 0/3] Fix the TIOCGICOUNT problem for good
Message-ID: <20100916184446.GA8803@kroah.com>
References: <20100916171747.25987.33573.stgit@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100916171747.25987.33573.stgit@localhost.localdomain>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 16, 2010 at 06:21:06PM +0100, Alan Cox wrote:
> Remembering to clear fields is something driver authors are simply never
> going to remember to get right every new driver. Instead take the problem
> away from them and give them a simple interface to do the job.

Looks good.  But is it ok if I keep the one driver patch I have now for
.36 and queue this up for .37?  I'll handle the merge conflicts myself.

thanks,

greg k-h
