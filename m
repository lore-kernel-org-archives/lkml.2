Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752270Ab1FIRyV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Jun 2011 13:54:21 -0400
Received: from cantor2.suse.de ([195.135.220.15]:47941 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751824Ab1FIRyU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Jun 2011 13:54:20 -0400
Date: Thu, 9 Jun 2011 10:53:13 -0700
From: Greg KH <gregkh@suse.de>
To: KY Srinivasan <kys@microsoft.com>
Cc: Greg KH <greg@kroah.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devel@linuxdriverproject.org" <devel@linuxdriverproject.org>,
        "virtualization@lists.osdl.org" <virtualization@lists.osdl.org>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        "Abhishek Kane (Mindtree Consulting PVT LTD)" 
	<v-abkane@microsoft.com>
Subject: Re: [PATCH 1/3] Staging: hv: netvsc: Fix a bug in accounting
 transmit slots
Message-ID: <20110609175313.GA1799@suse.de>
References: <1307401055-13608-1-git-send-email-kys@microsoft.com>
 <20110609170437.GA24686@kroah.com>
 <6E21E5352C11B742B20C142EB499E0480814575D@TK5EX14MBXC124.redmond.corp.microsoft.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6E21E5352C11B742B20C142EB499E0480814575D@TK5EX14MBXC124.redmond.corp.microsoft.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 09, 2011 at 05:23:50PM +0000, KY Srinivasan wrote:
> > -----Original Message-----
> > From: Greg KH [mailto:greg@kroah.com]
> > Sent: Thursday, June 09, 2011 1:05 PM
> > To: KY Srinivasan
> > Cc: gregkh@suse.de; linux-kernel@vger.kernel.org;
> > devel@linuxdriverproject.org; virtualization@lists.osdl.org; Haiyang Zhang;
> > Abhishek Kane (Mindtree Consulting PVT LTD)
> > Subject: Re: [PATCH 1/3] Staging: hv: netvsc: Fix a bug in accounting transmit slots
> > 
> > On Mon, Jun 06, 2011 at 03:57:35PM -0700, K. Y. Srinivasan wrote:
> > 
> > I only got 2 of these three patches, what happened to the third one?
> > 
> > Care to resend all 3 of these to ensure that I get them all?
> 
> There really were only 2 patches I wanted to send. If you want I could reformat
> and send only the 2 I wanted to send.

Please do, as when you send something that says 1/3 and 2/3 and 3/3
never shows up, we have no idea what is going on...

thanks,

greg k-h
