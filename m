Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936053Ab2KAQBU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Nov 2012 12:01:20 -0400
Received: from mga09.intel.com ([134.134.136.24]:5331 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933964Ab2KAQBP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Nov 2012 12:01:15 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.80,693,1344236400"; 
   d="scan'208";a="214020099"
Message-ID: <50929CC9.8040505@intel.com>
Date: Thu, 01 Nov 2012 09:01:13 -0700
From: Alexander Duyck <alexander.h.duyck@intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120911 Thunderbird/15.0.1
MIME-Version: 1.0
To: "H. Peter Anvin" <hpa@zytor.com>
CC: Andi Kleen <andi@firstfloor.org>, tglx@linutronix.de, mingo@redhat.com,
        linux-kernel@vger.kernel.org, x86@kernel.org
Subject: Re: [PATCH v2 0/8] Improve performance of VM translation on x86_64
References: <20121011204324.12787.30514.stgit@gitlad.jf.intel.com> <20121011224018.GY16230@one.firstfloor.org> <50774F14.60404@zytor.com>
In-Reply-To: <50774F14.60404@zytor.com>
X-Enigmail-Version: 1.4.4
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/11/2012 03:58 PM, H. Peter Anvin wrote:
> On 10/12/2012 06:40 AM, Andi Kleen wrote:
>> Patch series looks good to me. Thanks for doing this properly.
>> Reviewed-by: Andi Kleen <ak@linux.intel.com>
>>
> Agreed.
>
> Acked-by: H. Peter Anvin <hpa@zytor.com>
>
> I will pick this up after the merge window closes unless Ingo beats me
> to it.  (I'm currently traveling.)
>
> 	-hpa
>
>

I was wondering if this ever got picked up?  If so is there a public
tree I could find them in?

Just wondering since I have some minor changes I would like to make and
I just wanted to figure out if I should rework the patches or submit the
changes as a follow-on.

Thanks,

Alex
