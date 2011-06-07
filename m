Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756443Ab1FGURm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Jun 2011 16:17:42 -0400
Received: from cantor.suse.de ([195.135.220.2]:39633 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756334Ab1FGURl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Jun 2011 16:17:41 -0400
Date: Tue, 7 Jun 2011 13:09:52 -0700
From: Greg KH <gregkh@suse.de>
To: KY Srinivasan <kys@microsoft.com>
Cc: Greg KH <greg@kroah.com>, Christoph Hellwig <hch@infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devel@linuxdriverproject.org" <devel@linuxdriverproject.org>,
        "virtualization@lists.osdl.org" <virtualization@lists.osdl.org>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        "Abhishek Kane (Mindtree Consulting PVT LTD)" 
	<v-abkane@microsoft.com>
Subject: Re: [PATCH 24/49] Staging: hv: vmbus: Get rid of the unused wrapper
 - vmbus_onchannel_event()
Message-ID: <20110607200952.GA3243@suse.de>
References: <1307400540-13193-1-git-send-email-kys@microsoft.com>
 <1307400613-13234-1-git-send-email-kys@microsoft.com>
 <1307400613-13234-24-git-send-email-kys@microsoft.com>
 <20110606231511.GB18222@infradead.org>
 <6E21E5352C11B742B20C142EB499E0480813D861@TK5EX14MBXC122.redmond.corp.microsoft.com>
 <20110607185840.GB3531@kroah.com>
 <6E21E5352C11B742B20C142EB499E0480813DAF6@TK5EX14MBXC122.redmond.corp.microsoft.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6E21E5352C11B742B20C142EB499E0480813DAF6@TK5EX14MBXC122.redmond.corp.microsoft.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 07, 2011 at 07:58:50PM +0000, KY Srinivasan wrote:
> 
> 
> > -----Original Message-----
> > From: Greg KH [mailto:greg@kroah.com]
> > Sent: Tuesday, June 07, 2011 2:59 PM
> > To: KY Srinivasan
> > Cc: Christoph Hellwig; gregkh@suse.de; linux-kernel@vger.kernel.org;
> > devel@linuxdriverproject.org; virtualization@lists.osdl.org; Haiyang Zhang;
> > Abhishek Kane (Mindtree Consulting PVT LTD)
> > Subject: Re: [PATCH 24/49] Staging: hv: vmbus: Get rid of the unused wrapper -
> > vmbus_onchannel_event()
> > 
> > On Tue, Jun 07, 2011 at 02:59:32PM +0000, KY Srinivasan wrote:
> > >
> > >
> > > > -----Original Message-----
> > > > From: Christoph Hellwig [mailto:hch@infradead.org]
> > > > Sent: Monday, June 06, 2011 7:15 PM
> > > > To: KY Srinivasan
> > > > Cc: gregkh@suse.de; linux-kernel@vger.kernel.org;
> > > > devel@linuxdriverproject.org; virtualization@lists.osdl.org; Haiyang Zhang;
> > > > Abhishek Kane (Mindtree Consulting PVT LTD)
> > > > Subject: Re: [PATCH 24/49] Staging: hv: vmbus: Get rid of the unused wrapper
> > -
> > > > vmbus_onchannel_event()
> > > >
> > > > On Mon, Jun 06, 2011 at 03:49:48PM -0700, K. Y. Srinivasan wrote:
> > > > > Now, get rid of the unused wrapper - vmbus_onchannel_event().
> > > >
> > > > I'd merge this into the previous patch.  In general your patch split
> > > > seem a little too fine grained to me in general.  When you remove a
> > > > wrapper you can inline it into the callsite directly, if you clean up a
> > > > function directly inlining it into the helper is fine, etc.
> > > >
> > > I agree with you that some of these patches are too fine grained; but
> > > I thought that was what was expected - "one change per patch".
> > 
> > Yes, but don't take it to an extreme, like you have done here :)
> 
> Will do in the future. Should I re-spin any of the patches in this set to make them less
> "fine-grained".

No, they are fine as-is.
