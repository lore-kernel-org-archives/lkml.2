Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756657Ab1KXQhm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Nov 2011 11:37:42 -0500
Received: from cantor2.suse.de ([195.135.220.15]:43720 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753020Ab1KXQhl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Nov 2011 11:37:41 -0500
Date: Thu, 24 Nov 2011 08:24:26 -0800
From: Greg KH <gregkh@suse.de>
To: Ben Hutchings <ben@decadent.org.uk>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Marcus Osdoba <marcus.osdoba@googlemail.com>, 649216@bugs.debian.org
Subject: Re: [PATCH] topology: Provide CPU topology in sysfs in !SMP
 configurations
Message-ID: <20111124162426.GA4435@suse.de>
References: <1322118279.2839.255.camel@deadeye>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1322118279.2839.255.camel@deadeye>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 24, 2011 at 07:04:39AM +0000, Ben Hutchings wrote:
> We should provide topology information to userland even if it's not
> very interesting.  The current code appears to work properly for !SMP
> (tested on i386).

Why, what will the topology look like for this?

thanks,

greg k-h
