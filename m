Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759326Ab0I0RvE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Sep 2010 13:51:04 -0400
Received: from mx1.redhat.com ([209.132.183.28]:3339 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755266Ab0I0RvC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Sep 2010 13:51:02 -0400
Date: Mon, 27 Sep 2010 13:50:45 -0400
From: Don Zickus <dzickus@redhat.com>
To: Robert Richter <robert.richter@amd.com>
Cc: Huang Ying <ying.huang@intel.com>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Andi Kleen <andi@firstfloor.org>
Subject: Re: [PATCH -v2 3/7] x86, NMI, Rename memory parity error to PCI SERR
 error
Message-ID: <20100927175045.GD26290@redhat.com>
References: <1285549026-5008-1-git-send-email-ying.huang@intel.com>
 <1285549026-5008-3-git-send-email-ying.huang@intel.com>
 <20100927080106.GA32222@erda.amd.com>
 <1285576760.20791.70.camel@yhuang-dev>
 <20100927090056.GJ13563@erda.amd.com>
 <20100927153315.GB26290@redhat.com>
 <20100927164502.GS13563@erda.amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100927164502.GS13563@erda.amd.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 27, 2010 at 06:45:02PM +0200, Robert Richter wrote:
> On 27.09.10 11:33:15, Don Zickus wrote:
> > Well, what other info do we know besides that bit being set?  (I wish we
> > had more, but I don't think we do)
> 
> We should keep printing the reason byte as it did before.

oh right.  Fair enough.  Though in my experience, it always confuses
people.  They think they are getting different failures (0xa2 vs 0xb2 for
example).

Cheers,
Don
