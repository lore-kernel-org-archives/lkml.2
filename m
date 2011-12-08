Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751993Ab1LHU6H (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Dec 2011 15:58:07 -0500
Received: from mga03.intel.com ([143.182.124.21]:25007 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750834Ab1LHU6D (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Dec 2011 15:58:03 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="83759324"
Date: Thu, 8 Dec 2011 12:58:01 -0800
From: Andi Kleen <ak@linux.intel.com>
To: Jean Delvare <khali@linux-fr.org>
Cc: guenter.roeck@ericsson.com, Andi Kleen <andi@firstfloor.org>,
        linux-kernel@vger.kernel.org, Kay Sievers <kay.sievers@vrfy.org>,
        trenn@suse.de, fenghua.yu@intel.com
Subject: Re: [PATCH 06/10] HWMON: Convert coretemp to x86 cpuid autoprobing
Message-ID: <20111208205801.GA16125@tassilo.jf.intel.com>
References: <1323304882-27953-1-git-send-email-andi@firstfloor.org>
 <1323304882-27953-7-git-send-email-andi@firstfloor.org>
 <20111208024001.GA4912@ericsson.com>
 <20111208082402.3591123f@endymion.delvare>
 <1323360569.2415.16.camel@groeck-laptop>
 <20111208171303.796aa673@endymion.delvare>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111208171303.796aa673@endymion.delvare>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > Unless I am missing something, the patchset would have to change to
> > accept a const as parameter to x86_match_cpu().
> 
> Yes, I proposed that too in my review of the relevant patch.

Done.
-Andi
