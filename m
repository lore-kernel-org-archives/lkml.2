Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752125Ab1CPIue (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Mar 2011 04:50:34 -0400
Received: from www.tglx.de ([62.245.132.106]:59728 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751578Ab1CPIu2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Mar 2011 04:50:28 -0400
Message-ID: <4D8079BE.6050505@linutronix.de>
Date: Wed, 16 Mar 2011 09:50:06 +0100
From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
User-Agent: Mozilla-Thunderbird 2.0.0.24 (X11/20100329)
MIME-Version: 1.0
To: Stephen Rothwell <sfr@canb.auug.org.au>
CC: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Peter Zijlstra <peterz@infradead.org>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: linux-next: manual merge of the tip tree with Linus' tree
References: <20110316160842.493967db.sfr@canb.auug.org.au>
In-Reply-To: <20110316160842.493967db.sfr@canb.auug.org.au>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Stephen Rothwell wrote:
> Hi all,
Hi Stephen,

> Today's linux-next merge of the tip tree got a conflict in
> arch/x86/platform/ce4100/ce4100.c between commit 03150171dcf9 ("x86:
> ce4100: Set pci ops via callback instead of module init") from Linus'
> tree and commit 1fa4163bdc19 ("x86: ce4100: Use OF to setup devices")
> from the tip tree.

I just looked and Linus already pulled and fixed it up by himself. Thanks
for letting me know.

Sebastian
