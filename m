Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752522Ab2GSX2h (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jul 2012 19:28:37 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:52984 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751844Ab2GSX2f (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jul 2012 19:28:35 -0400
Date: Thu, 19 Jul 2012 16:28:32 -0700
From: "Greg KH (gregkh@linuxfoundation.org)" <gregkh@linuxfoundation.org>
To: KY Srinivasan <kys@microsoft.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>,
        "devel@linuxdriverproject.org" <devel@linuxdriverproject.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "virtualization@lists.osdl.org" <virtualization@lists.osdl.org>
Subject: Re: 0xB16B00B5? Really? (was Re: Move hyperv out of the
 drivers/staging/ directory)
Message-ID: <20120719232832.GA6317@kroah.com>
References: <6E21E5352C11B742B20C142EB499E048081EB789@TK5EX14MBXC124.redmond.corp.microsoft.com>
 <20111004170415.GA1320@suse.de>
 <6E21E5352C11B742B20C142EB499E048081EB86F@TK5EX14MBXC124.redmond.corp.microsoft.com>
 <20111004193414.GA15672@suse.de>
 <4FFFF711.8040003@redhat.com>
 <426367E2313C2449837CD2DE46E7EAF923547292@SN2PRD0310MB382.namprd03.prod.outlook.com>
 <20120719210709.GA32031@kroah.com>
 <426367E2313C2449837CD2DE46E7EAF9235475EE@SN2PRD0310MB382.namprd03.prod.outlook.com>
 <20120719220142.GA1513@kroah.com>
 <426367E2313C2449837CD2DE46E7EAF923547620@SN2PRD0310MB382.namprd03.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <426367E2313C2449837CD2DE46E7EAF923547620@SN2PRD0310MB382.namprd03.prod.outlook.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 19, 2012 at 10:30:38PM +0000, KY Srinivasan wrote:
> > > As you know, this ID has been in use for a long time now. While the hypervisor
> > > does not interpret the guest ID that is registered, I am not sure what
> > dependencies
> > > there might be on this value.
> > 
> > Could you please go find out the answer to this?
> 
> That is easier said than done. I have sent emails out asking this very question and I have
> not received a definitive answer yet. Not knowing if and when I can get a definitive
> answer here, I chose the least risky approach in my patch. 

What happens if you test with different values?

> > If, as you originally stated, there is a range of values we can use,
> > then we should probably use another one, right?
> 
> On the Windows side this ID namespace is managed well.

It is?  How is this managed?  What does this tell the hypervisor?  What
changes with the different values?

> However on the Linux side, we have really had this current ID in use
> for almost five years now. I am not aware of any pool of IDs available
> for Linux usage except that Linux IDs be distinct from the guest IDs
> in use by MSFT operating systems. If I were to change the guest ID, I
> would probably want to comply with the MSFT guidance on constructing
> these IDs (although not all fields may be relevant for Linux).

What are those rules?

thanks,

greg k-h
