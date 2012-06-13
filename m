Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752853Ab2FMARR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Jun 2012 20:17:17 -0400
Received: from terminus.zytor.com ([198.137.202.10]:47055 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751640Ab2FMARQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Jun 2012 20:17:16 -0400
Message-ID: <4FD7DBFE.3050203@zytor.com>
Date: Tue, 12 Jun 2012 17:17:02 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:12.0) Gecko/20120430 Thunderbird/12.0.1
MIME-Version: 1.0
To: Suresh Siddha <suresh.b.siddha@intel.com>
CC: Ingo Molnar <mingo@elte.hu>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Hans Rosenfeld <hans.rosenfeld@amd.com>,
        linux-kernel <linux-kernel@vger.kernel.org>, tglx@linutronix.de
Subject: Re: [RFC] x86, fpu: unify signal handling code paths for x86 and
 x86_64 kernels
References: <1339545814.28766.148.camel@sbsiddha-desk.sc.intel.com>
In-Reply-To: <1339545814.28766.148.camel@sbsiddha-desk.sc.intel.com>
X-Enigmail-Version: 1.4.1
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/12/2012 05:03 PM, Suresh Siddha wrote:
>  7 files changed, 256 insertions(+), 402 deletions(-)

I like what I see so far ;)

	-hpa

-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

