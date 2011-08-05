Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755914Ab1HEK6d (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Aug 2011 06:58:33 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:63216 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752839Ab1HEK6b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Aug 2011 06:58:31 -0400
Message-ID: <4E3BCCB4.7060208@ru.mvista.com>
Date: Fri, 05 Aug 2011 14:57:56 +0400
From: Sergei Shtylyov <sshtylyov@mvista.com>
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:5.0) Gecko/20110624 Thunderbird/5.0
MIME-Version: 1.0
To: David Brown <davidb@codeaurora.org>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
        Russell King <linux@arm.linux.org.uk>, Len Brown <len.brown@intel.com>,
        linux-sh@vger.kernel.org, Kevin Hilman <khilman@deeprootsystems.com>,
        linux-arm-msm@vger.kernel.org, x86@kernel.org,
        linux-kernel@vger.kernel.org, Paul Mundt <lethal@linux-sh.org>,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH] cpuidle: Consistent spelling of cpuidle_idle_call()
References: <1312475071-22973-1-git-send-email-davidb@codeaurora.org>
In-Reply-To: <1312475071-22973-1-git-send-email-davidb@codeaurora.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

On 04-08-2011 20:24, David Brown wrote:

> Commit a0bfa1373859e9d11dc92561a8667588803e42d8 mispells

    Please also specify that commit's summary in parens.

> cpuidle_idle_call() on ARM and SH code.  Fix this to be consistent.

> Cc: Kevin Hilman <khilman@deeprootsystems.com>
> Cc: Paul Mundt <lethal@linux-sh.org>
> Cc: x86@kernel.org
> Cc: Len Brown <len.brown@intel.com>
> Signed-off-by: David Brown<davidb@codeaurora.org>

WBR, Sergei
