Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753945Ab1F3T2i (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Jun 2011 15:28:38 -0400
Received: from cantor2.suse.de ([195.135.220.15]:41560 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752124Ab1F3T2g (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Jun 2011 15:28:36 -0400
Date: Thu, 30 Jun 2011 12:23:22 -0700
From: Greg KH <gregkh@suse.de>
To: Dan Magenheimer <dan.magenheimer@oracle.com>
Cc: Marcus Klemm <marcus.klemm@googlemail.com>,
        Seth Jennings <sjenning@linux.vnet.ibm.com>,
        Konrad Wilk <konrad.wilk@oracle.com>, linux-kernel@vger.kernel.org,
        devel@linuxdriverproject.org, kvm@vger.kernel.org,
        linux-mm <linux-mm@kvack.org>
Subject: Re: [PATCH v2] staging: zcache: support multiple clients, prep for
 KVM and RAMster
Message-ID: <20110630192322.GA1753@suse.de>
References: <1d15f28a-56df-4cf4-9dd9-1032f211c0d0@default>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1d15f28a-56df-4cf4-9dd9-1032f211c0d0@default>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 30, 2011 at 12:01:08PM -0700, Dan Magenheimer wrote:
> Hi Greg --
> 
> I think this patch is now ready for staging-next and for merging when
> the 3.1 window opens.  Please let me know if you need any logistics
> done differently.

Ok, thanks, I'll queue it up later this week for 3.1

greg k-h
