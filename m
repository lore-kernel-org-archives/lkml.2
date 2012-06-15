Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755411Ab2FOBNt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jun 2012 21:13:49 -0400
Received: from terminus.zytor.com ([198.137.202.10]:40331 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752157Ab2FOBNs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jun 2012 21:13:48 -0400
Message-ID: <4FDA8C36.1020803@zytor.com>
Date: Thu, 14 Jun 2012 18:13:26 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:12.0) Gecko/20120430 Thunderbird/12.0.1
MIME-Version: 1.0
To: Suresh Siddha <suresh.b.siddha@intel.com>
CC: Hans Rosenfeld <hans.rosenfeld@amd.com>, Ingo Molnar <mingo@elte.hu>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel <linux-kernel@vger.kernel.org>, tglx@linutronix.de,
        robert.richter@amd.com, andreas.herrmann3@amd.com
Subject: Re: [RFC] x86, fpu: unify signal handling code paths for x86 and
 x86_64 kernels
References: <1339545814.28766.148.camel@sbsiddha-desk.sc.intel.com>   <20120614143727.GF7922@escobedo.osrc.amd.com>  <1339719035.3475.52.camel@sbsiddha-desk.sc.intel.com>  <4FDA7EDE.3070408@zytor.com> <1339722435.3475.57.camel@sbsiddha-desk.sc.intel.com>
In-Reply-To: <1339722435.3475.57.camel@sbsiddha-desk.sc.intel.com>
X-Enigmail-Version: 1.4.2
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/14/2012 06:07 PM, Suresh Siddha wrote:
> Ok. Fix for the existing mainline code appended. Can you queue this
> separately?

Your unification patch still needs this too, though, right?

	-hpa

