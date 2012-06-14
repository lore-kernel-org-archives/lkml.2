Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756563Ab2FNUtF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jun 2012 16:49:05 -0400
Received: from terminus.zytor.com ([198.137.202.10]:38102 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754352Ab2FNUtD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jun 2012 16:49:03 -0400
Message-ID: <4FDA4E2E.7030503@zytor.com>
Date: Thu, 14 Jun 2012 13:48:46 -0700
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
> I can split the patch if needed. And I need to do little bit more
> validation (already tested on 64-bit IVB  and 32-bit NHM) before
> removing the 'RFC' tag.
> 
> I tried starting with the old version of Hans patch. But there were lot
> more changes in this area since then and also his patch had few
> user-visible compatibility issues.
> 
> Appended is the version that I came up with. Please review.
> 

This patch doesn't apply to v3.5-rc2.

	-hpa

-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

