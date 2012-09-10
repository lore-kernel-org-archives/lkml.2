Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758309Ab2IJTVt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Sep 2012 15:21:49 -0400
Received: from mga02.intel.com ([134.134.136.20]:54810 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758097Ab2IJTVr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Sep 2012 15:21:47 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.80,398,1344236400"; 
   d="scan'208";a="191275540"
Subject: Re: [PATCH 0/4] x86: xor-block handling adjustments
From: Suresh Siddha <suresh.b.siddha@intel.com>
Reply-To: Suresh Siddha <suresh.b.siddha@intel.com>
To: Jan Beulich <JBeulich@suse.com>
Cc: mingo@elte.hu, tglx@linutronix.de, hpa@zytor.com,
        linux-kernel@vger.kernel.org
Date: Mon, 10 Sep 2012 12:20:37 -0700
In-Reply-To: <504DFB10020000780009A321@nat28.tlf.novell.com>
References: <504DFB10020000780009A321@nat28.tlf.novell.com>
Organization: Intel Corp
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.0.3 (3.0.3-1.fc15) 
Content-Transfer-Encoding: 7bit
Message-ID: <1347304838.26695.99.camel@sbsiddha-desk.sc.intel.com>
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2012-09-10 at 13:37 +0100, Jan Beulich wrote:
> 1: unify SSE-base xor-block routines
> 2: improve XMM register spill/fill
> 3: add alternative SSE implementation only prefetching once per 64-byte line
> 4: make virtualization friendly
> 
> Signed-off-by: Jan Beulich <jbeulich@suse.com>

Jan, There are some relevant changes in tip/x86/fpu branch. Can you
please build your patches on top of that?

thanks,
suresh

