Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933401Ab2JKW6s (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Oct 2012 18:58:48 -0400
Received: from mga01.intel.com ([192.55.52.88]:30691 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932191Ab2JKW6r (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Oct 2012 18:58:47 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.80,573,1344236400"; 
   d="scan'208";a="233761608"
Message-ID: <50774F14.60404@zytor.com>
Date: Fri, 12 Oct 2012 06:58:28 +0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:13.0) Gecko/20120605 Thunderbird/13.0
MIME-Version: 1.0
To: Andi Kleen <andi@firstfloor.org>
CC: Alexander Duyck <alexander.h.duyck@intel.com>, tglx@linutronix.de,
        mingo@redhat.com, linux-kernel@vger.kernel.org, x86@kernel.org
Subject: Re: [PATCH v2 0/8] Improve performance of VM translation on x86_64
References: <20121011204324.12787.30514.stgit@gitlad.jf.intel.com> <20121011224018.GY16230@one.firstfloor.org>
In-Reply-To: <20121011224018.GY16230@one.firstfloor.org>
X-Enigmail-Version: 1.4.3
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/12/2012 06:40 AM, Andi Kleen wrote:
> 
> Patch series looks good to me. Thanks for doing this properly.
> Reviewed-by: Andi Kleen <ak@linux.intel.com>
> 

Agreed.

Acked-by: H. Peter Anvin <hpa@zytor.com>

I will pick this up after the merge window closes unless Ingo beats me
to it.  (I'm currently traveling.)

	-hpa


