Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755797Ab1EQQjW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 May 2011 12:39:22 -0400
Received: from mga03.intel.com ([143.182.124.21]:43705 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755445Ab1EQQjV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 May 2011 12:39:21 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.65,226,1304319600"; 
   d="scan'208";a="437616522"
Date: Tue, 17 May 2011 09:38:47 -0700
From: Andi Kleen <ak@linux.intel.com>
To: Don Zickus <dzickus@redhat.com>
Cc: Huang Ying <ying.huang@intel.com>, Cyrill Gorcunov <gorcunov@gmail.com>,
        huang ying <huang.ying.caritas@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Andi Kleen <andi@firstfloor.org>,
        Robert Richter <robert.richter@amd.com>
Subject: Re: [RFC] x86, NMI, Treat unknown NMI as hardware error
Message-ID: <20110517163847.GF24805@tassilo.jf.intel.com>
References: <1305275018-20596-1-git-send-email-ying.huang@intel.com>
 <4DCD4B85.3040702@gmail.com>
 <BANLkTin7LNo0dDLs-Rz6WqCQ9RvS=MLXcw@mail.gmail.com>
 <4DCE3493.4090404@gmail.com>
 <BANLkTin1pvdnXtw53MhwfCsEQpsu0TUUmg@mail.gmail.com>
 <4DCF7413.4070704@gmail.com>
 <4DD07959.4030608@intel.com>
 <20110516190310.GH31888@redhat.com>
 <4DD20A2F.604@intel.com>
 <20110517142427.GL31888@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110517142427.GL31888@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Can we agree on this, that if an OEM implemented HEST properly such that a
> hardware error happens it will generate a GHES record.  The subsequent NMI

Apparently there are some (rare) corner cases where it's hard/impossible
to do. So in those cases you will see an NMI without record.

In the "normal" error case you will a GHES record on NMI.

-Andi
