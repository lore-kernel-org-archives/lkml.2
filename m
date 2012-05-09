Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754089Ab2EINxq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 May 2012 09:53:46 -0400
Received: from mga14.intel.com ([143.182.124.37]:13645 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750797Ab2EINxp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 May 2012 09:53:45 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="98095297"
Message-ID: <4FAA76E7.1070807@linux.intel.com>
Date: Wed, 09 May 2012 06:53:43 -0700
From: "H. Peter Anvin" <hpa@linux.intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:11.0) Gecko/20120329 Thunderbird/11.0.1
MIME-Version: 1.0
To: Jarkko Sakkinen <jarkko.sakkinen@intel.com>
CC: Paolo Bonzini <pbonzini@redhat.com>, linux-kernel@vger.kernel.org,
        linux-kbuild@vger.kernel.org, Michal Marek <mmarek@suse.cz>,
        Sam Ravnborg <sam@ravnborg.org>,
        Joseph Cihula <joseph.cihula@intel.com>,
        Shane Wang <shane.wang@intel.com>
Subject: Re: [PATCH 04/23] x86, realmode: Move reboot_32.S to unified realmode
 code
References: <1336501366-28617-1-git-send-email-jarkko.sakkinen@intel.com> <1336501366-28617-5-git-send-email-jarkko.sakkinen@intel.com> <4FAA18F1.6080508@redhat.com> <alpine.DEB.2.02.1205091525100.6943@jsakkine-mobl2.(null)>
In-Reply-To: <alpine.DEB.2.02.1205091525100.6943@jsakkine-mobl2.(null)>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/09/2012 05:37 AM, Jarkko Sakkinen wrote:
> 
> It's true that it doesn't matter much but still it is a
> regression. And it doesn't cause any kind of overhead
> or bloat to fix this.
> 

However, the big thing is that we jump to the BIOS with caches off.  I
personally think it is the wrong thing to do (we don't jump to the real
reset vector anyway) but it is what has been tested for a long time.

	-hpa

