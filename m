Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755002Ab1GNV0d (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jul 2011 17:26:33 -0400
Received: from terminus.zytor.com ([198.137.202.10]:57030 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754801Ab1GNV0c (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jul 2011 17:26:32 -0400
Message-ID: <4E1F5EF3.6050601@zytor.com>
Date: Thu, 14 Jul 2011 14:26:11 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110428 Fedora/3.1.10-1.fc15 Thunderbird/3.1.10
MIME-Version: 1.0
To: Frederic Weisbecker <fweisbec@gmail.com>
CC: Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Jason Wessel <jason.wessel@windriver.com>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH 3/6] x86: Allow the user not to build hw_breakpoints
References: <1310655837-328-1-git-send-email-fweisbec@gmail.com> <1310655837-328-4-git-send-email-fweisbec@gmail.com>
In-Reply-To: <1310655837-328-4-git-send-email-fweisbec@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/14/2011 08:03 AM, Frederic Weisbecker wrote:
> So that hw_breakpoints and perf can be not built on
> specific embedded systems.

I want to emphasize I am very, very unhappy about this.  It should be
possible to not build perf while still have breakpoints available...
breakpoints are way more important than perf.

	-hpa
