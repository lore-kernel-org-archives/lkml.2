Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752595Ab1K3WRH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Nov 2011 17:17:07 -0500
Received: from cantor2.suse.de ([195.135.220.15]:53723 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752002Ab1K3WRG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Nov 2011 17:17:06 -0500
Date: Wed, 30 Nov 2011 13:57:50 -0800
From: Greg KH <gregkh@suse.de>
To: Haiyang Zhang <haiyangz@microsoft.com>
Cc: David Miller <davem@davemloft.net>, KY Srinivasan <kys@microsoft.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "devel@linuxdriverproject.org" <devel@linuxdriverproject.org>
Subject: Re: [PATCH 1/2] net/hyperv: Fix long lines in netvsc.c
Message-ID: <20111130215750.GB28990@suse.de>
References: <1322666348-6554-1-git-send-email-haiyangz@microsoft.com>
 <20111130.123626.308237192773284976.davem@davemloft.net>
 <A1F3067C9B68744AA19F6802BAB8FFDC0CCD01B1@TK5EX14MBXC227.redmond.corp.microsoft.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <A1F3067C9B68744AA19F6802BAB8FFDC0CCD01B1@TK5EX14MBXC227.redmond.corp.microsoft.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 30, 2011 at 07:13:49PM +0000, Haiyang Zhang wrote:
> > -----Original Message-----
> > From: David Miller [mailto:davem@davemloft.net]
> > Sent: Wednesday, November 30, 2011 12:36 PM
> > To: Haiyang Zhang
> > Cc: KY Srinivasan; gregkh@suse.de; linux-kernel@vger.kernel.org;
> > netdev@vger.kernel.org; devel@linuxdriverproject.org
> > Subject: Re: [PATCH 1/2] net/hyperv: Fix long lines in netvsc.c
> > 
> > 
> > Well, since Greg's tree is where the staging move happened, he'll have
> > to take any patches to this driver that happen now, rather than me.
> 
> Sounds good. And, these patches were sent to devel@linuxdriverproject.org
> too.
> 
> Greg, could you consider these patches for your tree?

Yes, I'll queue them up, thanks.

greg k-h
