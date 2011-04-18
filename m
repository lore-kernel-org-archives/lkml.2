Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754984Ab1DROnY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Apr 2011 10:43:24 -0400
Received: from terminus.zytor.com ([198.137.202.10]:54120 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754258Ab1DROnT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Apr 2011 10:43:19 -0400
Message-ID: <4DAC4DEF.3090200@zytor.com>
Date: Mon, 18 Apr 2011 07:42:55 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.15) Gecko/20110403 Fedora/3.1.9-6.fc15 Thunderbird/3.1.9
MIME-Version: 1.0
To: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
CC: "H. Peter Anvin" <hpa@linux.intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>,
        "konrad.wilk@oracle.com" <konrad.wilk@oracle.com>,
        "jeremy@goop.org" <jeremy@goop.org>,
        "yinghai@kernel.org" <yinghai@kernel.org>,
        "mingo@elte.hu" <mingo@elte.hu>
Subject: Re: [PATCH 2/4] x86,xen: introduce x86_init.mapping.pagetable_reserve
References: <alpine.DEB.2.00.1104121149280.22672@kaball-desktop> <1302607192-21355-2-git-send-email-stefano.stabellini@eu.citrix.com> <4DA5EAE4.2060406@linux.intel.com> <alpine.DEB.2.00.1104141218110.22672@kaball-desktop> <4DA70A4A.4030805@zytor.com> <alpine.DEB.2.00.1104141746430.10886@kaball-desktop> <alpine.DEB.2.00.1104181507180.10886@kaball-desktop>
In-Reply-To: <alpine.DEB.2.00.1104181507180.10886@kaball-desktop>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/18/2011 07:09 AM, Stefano Stabellini wrote:
> 
> Sorry, I don't mean to be pushy, it is just that I'll be AFK for 12 days
> starting from next Friday and I think that this issue should really be
> fixed in time for the 2.6.39 release, otherwise no 2.6.39 kernels will
> be able to boot on any xen system.

YOU STILL HAVEN'T PROPOSED ANY SEMANTICS.

The semantics of a hook is a description of what the preconditions are,
what the postconditions are, and what exactly they are allowed or not
allowed to do.

This is a real pain to do, *exactly because hooks are a real pain*.
Most hooks that have been put in has been "oh, just do something at
point X in the code", which is a case of definition by implementation,
which is exactly how we ended up with the current mess.

	-hpa

-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

