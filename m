Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753444Ab1GUSEK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jul 2011 14:04:10 -0400
Received: from terminus.zytor.com ([198.137.202.10]:57973 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751419Ab1GUSEI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jul 2011 14:04:08 -0400
Message-ID: <4E2869F8.4060502@zytor.com>
Date: Thu, 21 Jul 2011 11:03:36 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.18) Gecko/20110621 Fedora/3.1.11-1.fc15 Thunderbird/3.1.11
MIME-Version: 1.0
To: David Ahern <dsahern@gmail.com>
CC: mingo@redhat.com, linux-kernel@vger.kernel.org, fweisbec@gmail.com,
        a.p.zijlstra@chello.nl, stable@kernel.org, tglx@linutronix.de,
        mingo@elte.hu, linux-tip-commits@vger.kernel.org
Subject: Re: [tip:perf/urgent] perf tools, x86: Fix 32-bit compile on 64-bit
 system
References: <1310420304-21452-1-git-send-email-dsahern@gmail.com> <tip-08a4a43fc407d780bdde36d98f89c0dbb2a6be6b@git.kernel.org> <4E284EAB.1020906@zytor.com> <4E2852C3.50109@gmail.com>
In-Reply-To: <4E2852C3.50109@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/21/2011 09:24 AM, David Ahern wrote:
> 
> Indeed that works fine. If that is the preferred route then the patch
> needs to update the following comment in the Makefile:
> 
> # Define EXTRA_CFLAGS=-m64 or EXTRA_CFLAGS=-m32 as appropriate for
> cross-builds.
> 
> to specify ARCH on the command line.
> 

And that it should.

	-hpa

-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

