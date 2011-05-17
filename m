Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756122Ab1EQSTc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 May 2011 14:19:32 -0400
Received: from mga01.intel.com ([192.55.52.88]:42858 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756015Ab1EQSTb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 May 2011 14:19:31 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.65,226,1304319600"; 
   d="scan'208";a="3476983"
Date: Tue, 17 May 2011 11:18:59 -0700
From: Andi Kleen <ak@linux.intel.com>
To: Don Zickus <dzickus@redhat.com>
Cc: Huang Ying <ying.huang@intel.com>, Cyrill Gorcunov <gorcunov@gmail.com>,
        huang ying <huang.ying.caritas@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Andi Kleen <andi@firstfloor.org>,
        Robert Richter <robert.richter@amd.com>
Subject: Re: [RFC] x86, NMI, Treat unknown NMI as hardware error
Message-ID: <20110517181859.GA25937@tassilo.jf.intel.com>
References: <BANLkTin7LNo0dDLs-Rz6WqCQ9RvS=MLXcw@mail.gmail.com>
 <4DCE3493.4090404@gmail.com>
 <BANLkTin1pvdnXtw53MhwfCsEQpsu0TUUmg@mail.gmail.com>
 <4DCF7413.4070704@gmail.com>
 <4DD07959.4030608@intel.com>
 <20110516190310.GH31888@redhat.com>
 <4DD20A2F.604@intel.com>
 <20110517142427.GL31888@redhat.com>
 <20110517163847.GF24805@tassilo.jf.intel.com>
 <20110517175707.GP31888@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110517175707.GP31888@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Random thought, in the Firmware first mode of HEST (which is the only way
> GHES records get produced??), does an SCI happen first to jump into the
> firmware for processing, then an NMI?

Either that or there is a separate service processor which handles it.
Presumably it depends a lot on the particular system.

-Andi
