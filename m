Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759172Ab1D2P1o (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Apr 2011 11:27:44 -0400
Received: from cantor2.suse.de ([195.135.220.15]:36339 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759049Ab1D2P1j (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Apr 2011 11:27:39 -0400
Date: Fri, 29 Apr 2011 08:08:04 -0700
From: Greg KH <gregkh@suse.de>
To: KY Srinivasan <kys@microsoft.com>
Cc: Greg KH <greg@kroah.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devel@linuxdriverproject.org" <devel@linuxdriverproject.org>,
        "virtualization@lists.osdl.org" <virtualization@lists.osdl.org>
Subject: Re: [PATCH 00/25] Staging: hv: Cleanup vmbus driver code
Message-ID: <20110429150804.GB12142@suse.de>
References: <1303834785-4981-1-git-send-email-kys@microsoft.com>
 <20110426232843.GA31184@kroah.com>
 <6E21E5352C11B742B20C142EB499E0481DD185@TK5EX14MBXC124.redmond.corp.microsoft.com>
 <20110428002817.GE14294@kroah.com>
 <6E21E5352C11B742B20C142EB499E0481DD5AA@TK5EX14MBXC124.redmond.corp.microsoft.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6E21E5352C11B742B20C142EB499E0481DD5AA@TK5EX14MBXC124.redmond.corp.microsoft.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 29, 2011 at 02:26:13PM +0000, KY Srinivasan wrote:
> Perhaps I did not properly formulate my question here. The review
> process itself may be open-ended, and that is fine - we will fix all legitimate
> issues/concerns  in our drivers whether they are in the staging area or not. 
> My question was specifically with regards to the review process that may gate exiting
> staging. I am hoping to re-spin the remaining patches of the last patch-set and send it to
> you by early next week and ask for a review. I fully intend to address whatever review 
> comments I may get in a very timely manner. Assuming at some point in time after I ask
> for this review there are no outstanding issues, would that be sufficient to exit staging?  

If it looks acceptable to me, and there are no other objections from
other developers, then yes, that would be sufficient to move it out of
staging.

thanks,

greg k-h
