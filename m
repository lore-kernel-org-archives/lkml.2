Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756073Ab2EHVVq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 May 2012 17:21:46 -0400
Received: from mga03.intel.com ([143.182.124.21]:7321 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751445Ab2EHVVp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 May 2012 17:21:45 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="140554567"
Message-ID: <4FA98E67.6080808@intel.com>
Date: Tue, 08 May 2012 14:21:43 -0700
From: "H. Peter Anvin" <h.peter.anvin@intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:11.0) Gecko/20120329 Thunderbird/11.0.1
MIME-Version: 1.0
To: Sam Ravnborg <sam@ravnborg.org>
CC: "H. Peter Anvin" <hpa@linux.intel.com>,
        Jarkko Sakkinen <jarkko.sakkinen@intel.com>,
        linux-kernel@vger.kernel.org, linux-kbuild@vger.kernel.org,
        Michal Marek <mmarek@suse.cz>, Joseph Cihula <joseph.cihula@intel.com>,
        Shane Wang <shane.wang@intel.com>
Subject: Re: [PATCH 02/23] x86, realmode: realmode.bin infrastructure
References: <1336501366-28617-1-git-send-email-jarkko.sakkinen@intel.com> <1336501366-28617-3-git-send-email-jarkko.sakkinen@intel.com> <20120508185349.GA12013@merkur.ravnborg.org> <4FA9709F.6020700@linux.intel.com> <4FA97ED3.1060105@intel.com> <20120508211112.GA12167@merkur.ravnborg.org>
In-Reply-To: <20120508211112.GA12167@merkur.ravnborg.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/08/2012 02:11 PM, Sam Ravnborg wrote:
> 
> Agreed.
> It just hurst my stummack big-time when KBUILD_CFLAGS are manupulated
> in a "random" Makefile.
> Last time we looked at this I failed to come up with something better.
> 

Yes, I agree it sucks big time.  If nothing else the bits in
arch/x86/boot and arch/x86/realmode/rm should be merged at some point.

	-hpa


