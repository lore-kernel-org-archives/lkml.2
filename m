Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760462Ab0I1BWf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Sep 2010 21:22:35 -0400
Received: from mga11.intel.com ([192.55.52.93]:60662 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751410Ab0I1BWe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Sep 2010 21:22:34 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.57,244,1283756400"; 
   d="scan'208";a="841485853"
Subject: Re: [PATCH -v2 3/7] x86, NMI, Rename memory parity error to PCI
 SERR error
From: Huang Ying <ying.huang@intel.com>
To: Don Zickus <dzickus@redhat.com>
Cc: Robert Richter <robert.richter@amd.com>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Andi Kleen <andi@firstfloor.org>
In-Reply-To: <20100927153315.GB26290@redhat.com>
References: <1285549026-5008-1-git-send-email-ying.huang@intel.com>
	 <1285549026-5008-3-git-send-email-ying.huang@intel.com>
	 <20100927080106.GA32222@erda.amd.com>
	 <1285576760.20791.70.camel@yhuang-dev>
	 <20100927090056.GJ13563@erda.amd.com>  <20100927153315.GB26290@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 28 Sep 2010 09:22:14 +0800
Message-ID: <1285636934.20791.136.camel@yhuang-dev>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2010-09-27 at 23:33 +0800, Don Zickus wrote:
> On Mon, Sep 27, 2010 at 11:00:56AM +0200, Robert Richter wrote:
> > On 27.09.10 04:39:20, Huang Ying wrote:
> > > > I already commented on this, patch #1 and #3 are basically the same in
> > > > most parts which should be merged. What remains then in this patch is
> > > > the modified printk() and the comment. Both could be added to #1 too
> > > > which is then some sort of code cleanup patch.
> > > 
> > > Don thinks it is Ok to keep 2 patches.
> > 
> > I don't like reviewing new changes which are thrown away with the next
> > patch. I review things twice and it is much harder to see what really
> > changed then. Also we should have a clean history.
> 
> I didn't care either way.  But if it makes it easier to review, it's nice
> to keep reviewers happy too. :-)
> 
> Hunag, I think there is going to be a V3 of this series, could you just
> combine these patches then?

Ok. I don't care much to this too in fact.

Best Regards,
Huang Ying


