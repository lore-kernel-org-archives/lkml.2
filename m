Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754739Ab1G0QCk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jul 2011 12:02:40 -0400
Received: from mga09.intel.com ([134.134.136.24]:9358 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754724Ab1G0QCg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jul 2011 12:02:36 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,276,1309762800"; 
   d="scan'208";a="30757165"
Message-ID: <4E30369B.8030708@linux.intel.com>
Date: Wed, 27 Jul 2011 09:02:35 -0700
From: Andi Kleen <ak@linux.intel.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 6.1; en-US; rv:1.9.2.15) Gecko/20110303 Thunderbird/3.1.9
MIME-Version: 1.0
To: Tim Gardner <tim.gardner@canonical.com>
CC: Andi Kleen <andi@firstfloor.org>, ebiederm@xmission.com, dan@aloni.org,
        davem@davemloft.net, gregkh@suse.de, linux-kernel@vger.kernel.org,
        stable@kernel.org, tim.bird@am.sony.com, stable@vger.kernel.org
Subject: Re: [stable] [PATCH] [26/98] af_unix: Only allow recv on connected
 seqpacket sockets.
References: <20110726534.972201586@firstfloor.org> <20110727003518.6DA772403FF@tassilo.jf.intel.com> <4E3035BE.6090908@canonical.com>
In-Reply-To: <4E3035BE.6090908@canonical.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> Andi - Ubuntu has reverted this patch for both Lucid (2.6.32) and 
> Natty (2.6.38) as it appears to cause a networking regression, though 
> we never really figured out root cause. Empirically, reverting the 
> patch solved the issue. Eric Biederman theorized that it uncovered a 
> user space issue (trying to read before listen), but the bug reporter 
> seems to have lost interest in testing kernels so we couldn't ever pin 
> it down.
>
> http://bugs.launchpad.net/bugs/791512
>
> We also decided that reverting this patch was likely OK because we 
> couldn't find any Launchpad reports of the Ooops mentioned in the 
> patch commit log, nor does a google search turn up any hits.

Thanks for the heads-up. I'm dropping it.

-Andi


