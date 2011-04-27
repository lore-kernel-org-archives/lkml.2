Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932842Ab1D0Rjb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Apr 2011 13:39:31 -0400
Received: from terminus.zytor.com ([198.137.202.10]:53273 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753528Ab1D0Rja (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Apr 2011 13:39:30 -0400
Message-ID: <4DB854AA.6070101@zytor.com>
Date: Wed, 27 Apr 2011 10:38:50 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.15) Gecko/20110422 Fedora/3.1.9-7.fc15 Thunderbird/3.1.9
MIME-Version: 1.0
To: Frederic Weisbecker <fweisbec@gmail.com>
CC: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Jason Wessel <jason.wessel@windriver.com>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH 3/6] x86: Allow the user not to build hw_breakpoints
References: <1303923602-2923-1-git-send-email-fweisbec@gmail.com> <1303923602-2923-4-git-send-email-fweisbec@gmail.com>
In-Reply-To: <1303923602-2923-4-git-send-email-fweisbec@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/27/2011 09:59 AM, Frederic Weisbecker wrote:
> So that hw_breakpoints and perf can be not built on
> specific embedded systems.

How big of a win, if any, is this, really?

	-hpa

-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

