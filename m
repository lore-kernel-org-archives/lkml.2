Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754972Ab2K2W21 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Nov 2012 17:28:27 -0500
Received: from terminus.zytor.com ([198.137.202.10]:53177 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754646Ab2K2W2Z (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Nov 2012 17:28:25 -0500
Message-ID: <50B7E146.4060907@zytor.com>
Date: Thu, 29 Nov 2012 14:27:18 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Andi Kleen <andi@firstfloor.org>
CC: Jim Kukunas <james.t.kukunas@linux.intel.com>,
        Linux Raid <linux-raid@vger.kernel.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Neil Brown <neilb@suse.de>
Subject: Re: [PATCH] lib/raid6: Add AVX2 optimized recovery functions
References: <1352411264-5156-1-git-send-email-james.t.kukunas@linux.intel.com> <m2obigf9xa.fsf@firstfloor.org> <50B7CFF8.7010401@zytor.com> <20121129211828.GZ16230@one.firstfloor.org>
In-Reply-To: <20121129211828.GZ16230@one.firstfloor.org>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/29/2012 01:18 PM, Andi Kleen wrote:
> 
> Can you quote it from the manual? As I understand volatile as usual
> is not clearly defined. 
> 
> gcc has a lot of optimization passes and volatile bugs are common.
> 

I talked it over with H.J. and we walked through the code.  The
documentation is lacking, of course, as is common with gcc.

However, that piece was pretty clear.

	-hpa

