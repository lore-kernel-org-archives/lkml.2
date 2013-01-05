Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755667Ab3AECsn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jan 2013 21:48:43 -0500
Received: from mga09.intel.com ([134.134.136.24]:45304 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755567Ab3AECsm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jan 2013 21:48:42 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,413,1355126400"; 
   d="scan'208";a="242289431"
Date: Sat, 5 Jan 2013 09:55:19 -0500
From: Youquan Song <youquan.song@linux.intel.com>
To: Yinghai Lu <yinghai@kernel.org>
Cc: "H. Peter Anvin" <hpa@linux.intel.com>,
        Youquan Song <youquan.song@intel.com>, linux-kernel@vger.kernel.org,
        tglx@linutronix.de, mingo@kernel.org,
        Youquan Song <youquan.song@linux.intel.com>
Subject: Re: [PATCH] x86,apic: Blacklist x2APIC on some platforms
Message-ID: <20130105145519.GB32169@linux-youquan.bj.intel.com>
References: <1355850450-26445-1-git-send-email-youquan.song@intel.com> <50D0A8CE.7040704@linux.intel.com> <CAE9FiQUfCOip_dJM9gTVsiXH5iHHPzTsnp=sBz2ughMJh1HT8Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAE9FiQUfCOip_dJM9gTVsiXH5iHHPzTsnp=sBz2ughMJh1HT8Q@mail.gmail.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 18, 2012 at 09:42:30AM -0800, Yinghai Lu wrote:
> On Tue, Dec 18, 2012 at 9:33 AM, H. Peter Anvin <hpa@linux.intel.com> wrote:
> > On 12/18/2012 09:07 AM, Youquan Song wrote:
> >> Blacklist x2apic when Nivida graphics enabled on Lenovo ThinkPad T420.
> >> Also set blacklist x2apic for Lenovo ThinkPad W520 and L520.
> >
> > I thought we had gotten reports that the Nvidia correlation was false?
> 
> that's T520.

Hi hpa,

Yinghai's T520 works when x2APIC enabled, so do not need to blacklist.

Would you like to take the patch?

Thanks
-Youquan
 
