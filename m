Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756404Ab1JSOgv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Oct 2011 10:36:51 -0400
Received: from cantor2.suse.de ([195.135.220.15]:39530 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752901Ab1JSOgu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Oct 2011 10:36:50 -0400
Date: Wed, 19 Oct 2011 07:36:32 -0700
From: Greg KH <gregkh@suse.de>
To: David Miller <davem@davemloft.net>
Cc: ebiederm@xmission.com, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, htejun@gmail.com, fubar@us.ibm.com,
        andy@greyhouse.net
Subject: Re: [PATCH 0/5] Better namespace handling for
 /sys/class/net/bonding_masters
Message-ID: <20111019143632.GA16783@suse.de>
References: <m1hb3dbae5.fsf@fess.ebiederm.org>
 <20111019.000932.523712028439316177.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111019.000932.523712028439316177.davem@davemloft.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 19, 2011 at 12:09:32AM -0400, David Miller wrote:
> From: ebiederm@xmission.com (Eric W. Biederman)
> Date: Thu, 13 Oct 2011 00:47:46 -0700
> 
> > Greg, Dave I'm don't know whose tree to merge this through as this code
> > is equally device-core and networking.  I am hoping that we can get this
> > improvement merged for 3.2.
> 
> I'm happy to take this series into my net-next tree.
> 
> Greg?  Any objections?

Nope:
	Acked-by: Greg Kroah-Hartman <gregkh@suse.de>


