Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754934Ab0FCHLu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jun 2010 03:11:50 -0400
Received: from mga09.intel.com ([134.134.136.24]:31209 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751440Ab0FCHLs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jun 2010 03:11:48 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.53,352,1272870000"; 
   d="scan'208";a="523542919"
Message-ID: <4C0755B7.8030304@linux.intel.com>
Date: Thu, 03 Jun 2010 09:11:51 +0200
From: "H. Peter Anvin" <hpa@linux.intel.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100430 Fedora/3.0.4-2.fc12 Thunderbird/3.0.4
MIME-Version: 1.0
To: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
CC: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] x86, cpufeature: Suppress compiler warning with gcc 3.x
References: <201006030452.o534qPZa022225@www262.sakura.ne.jp>
In-Reply-To: <201006030452.o534qPZa022225@www262.sakura.ne.jp>
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/03/2010 06:52 AM, Tetsuo Handa wrote:
> Gcc 3.x generates a warning
> 
>    arch/x86/include/asm/cpufeature.h: In function `__static_cpu_has':
>    arch/x86/include/asm/cpufeature.h:315: warning: asm operand 1 probably doesn't match constraints
> 
> on each file.
> But static_cpu_has() for gcc 3.x does not need __static_cpu_has().
> 
> Signed-off-by: Tetsuo Handa<penguin-kernel@I-love.SAKURA.ne.jp>

Patch already queued for this.

Why are you trying to compile a current kernel with gcc 3.x?

	-hpa
