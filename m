Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754394Ab0ISAOJ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Sep 2010 20:14:09 -0400
Received: from mga01.intel.com ([192.55.52.88]:13094 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753440Ab0ISAOI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Sep 2010 20:14:08 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.56,387,1280732400"; 
   d="scan'208";a="838901631"
Subject: Re: 7ad6e9435596f692ff65f399da12816c94960185 breaks AMD f10h.
From: Huang Ying <ying.huang@intel.com>
To: Conny Seidel <conny.seidel@amd.com>, "Brown, Len" <len.brown@intel.com>
Cc: Andi Kleen <ak@linux.intel.com>, LKML <linux-kernel@vger.kernel.org>,
        "borislav.petkov@" <amd.com.borislav.petkov@amd.com>,
        Jin Dongming <jin.dongming@np.css.fujitsu.com>
In-Reply-To: <20100917145625.75d2a412@marah.osrc.amd.com>
References: <20100917145625.75d2a412@marah.osrc.amd.com>
Content-Type: text/plain; charset="UTF-8"
Date: Sun, 19 Sep 2010 08:14:06 +0800
Message-ID: <1284855246.32373.291.camel@yhuang-dev>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, Conny,

On Fri, 2010-09-17 at 20:56 +0800, Conny Seidel wrote:
> Hi,
> 
> Kernel v2.6.36-rc4-134-g03a7ab0 breaks with the OOPS below.
> 
> Reverting the commitid in the subject fixes the issue.
> This is because APEI is selected by default on X86 (X86 && ACPI),
> maybe a vendor check in the hest_init() might make sense.

It seems that Dongming has reported and fixed this BUG. Please try this
fixes:

http://lkml.org/lkml/2010/9/2/52

Hi, Len,

Can you apply the BUG FIX?

Best Regards,
Huang Ying


