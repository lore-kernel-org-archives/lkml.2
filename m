Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758002Ab1FGTCU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Jun 2011 15:02:20 -0400
Received: from out3.smtp.messagingengine.com ([66.111.4.27]:34505 "EHLO
	out3.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756141Ab1FGTCM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Jun 2011 15:02:12 -0400
X-Sasl-enc: dNX3fsVEIk0nbrAlwtjbTkboiJEJNFVmNPPURHMOVFVA 1307473332
Date: Tue, 7 Jun 2011 11:58:40 -0700
From: Greg KH <greg@kroah.com>
To: KY Srinivasan <kys@microsoft.com>
Cc: Christoph Hellwig <hch@infradead.org>, "gregkh@suse.de" <gregkh@suse.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devel@linuxdriverproject.org" <devel@linuxdriverproject.org>,
        "virtualization@lists.osdl.org" <virtualization@lists.osdl.org>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        "Abhishek Kane (Mindtree Consulting PVT LTD)" 
	<v-abkane@microsoft.com>
Subject: Re: [PATCH 24/49] Staging: hv: vmbus: Get rid of the unused wrapper
 - vmbus_onchannel_event()
Message-ID: <20110607185840.GB3531@kroah.com>
References: <1307400540-13193-1-git-send-email-kys@microsoft.com>
 <1307400613-13234-1-git-send-email-kys@microsoft.com>
 <1307400613-13234-24-git-send-email-kys@microsoft.com>
 <20110606231511.GB18222@infradead.org>
 <6E21E5352C11B742B20C142EB499E0480813D861@TK5EX14MBXC122.redmond.corp.microsoft.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6E21E5352C11B742B20C142EB499E0480813D861@TK5EX14MBXC122.redmond.corp.microsoft.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 07, 2011 at 02:59:32PM +0000, KY Srinivasan wrote:
> 
> 
> > -----Original Message-----
> > From: Christoph Hellwig [mailto:hch@infradead.org]
> > Sent: Monday, June 06, 2011 7:15 PM
> > To: KY Srinivasan
> > Cc: gregkh@suse.de; linux-kernel@vger.kernel.org;
> > devel@linuxdriverproject.org; virtualization@lists.osdl.org; Haiyang Zhang;
> > Abhishek Kane (Mindtree Consulting PVT LTD)
> > Subject: Re: [PATCH 24/49] Staging: hv: vmbus: Get rid of the unused wrapper -
> > vmbus_onchannel_event()
> > 
> > On Mon, Jun 06, 2011 at 03:49:48PM -0700, K. Y. Srinivasan wrote:
> > > Now, get rid of the unused wrapper - vmbus_onchannel_event().
> > 
> > I'd merge this into the previous patch.  In general your patch split
> > seem a little too fine grained to me in general.  When you remove a
> > wrapper you can inline it into the callsite directly, if you clean up a
> > function directly inlining it into the helper is fine, etc.
> > 
> I agree with you that some of these patches are too fine grained; but 
> I thought that was what was expected - "one change per patch".

Yes, but don't take it to an extreme, like you have done here :)

thanks,

greg k-h
