Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751505Ab1GUEQT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jul 2011 00:16:19 -0400
Received: from one.firstfloor.org ([213.235.205.2]:36631 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750999Ab1GUEQS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jul 2011 00:16:18 -0400
Date: Thu, 21 Jul 2011 06:16:10 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Huang Ying <ying.huang@intel.com>
Cc: Andi Kleen <andi@firstfloor.org>, Len Brown <lenb@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Luck, Tony" <tony.luck@intel.com>,
        "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>,
        Matthew Garrett <mjg@redhat.com>
Subject: Re: [BUGFIX] ACPI, APEI, EINJ Param support is disabled by default
Message-ID: <20110721041610.GL8006@one.firstfloor.org>
References: <1311149369-20624-1-git-send-email-ying.huang@intel.com> <20110721024204.GJ8006@one.firstfloor.org> <4E2794D5.1030104@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4E2794D5.1030104@intel.com>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 21, 2011 at 10:54:13AM +0800, Huang Ying wrote:
> On 07/21/2011 10:42 AM, Andi Kleen wrote:
> >>  
> >> +static bool param_extension;
> >> +module_param(param_extension, bool, 0);
> > 
> > Make it 0644, then it can be changed at runtime. No need to require a reboot.
> 
> Normally, EINJ is compiled as module, so we can change it at load time
> without a reboot.

Ok. 

> 
> Do we need the real runtime switching capability?

I usually do that with modparams when it's possible. After all it's very
simple and doesn't cost anything.

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only.
