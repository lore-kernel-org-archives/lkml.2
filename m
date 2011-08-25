Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755196Ab1HYSNZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Aug 2011 14:13:25 -0400
Received: from claw.goop.org ([74.207.240.146]:56096 "EHLO claw.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753685Ab1HYSNY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Aug 2011 14:13:24 -0400
Message-ID: <4E5690C3.2050706@goop.org>
Date: Thu, 25 Aug 2011 11:13:23 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:6.0) Gecko/20110816 Thunderbird/6.0
MIME-Version: 1.0
To: Stephen Rothwell <sfr@canb.auug.org.au>
CC: Xen Devel <Xen-devel@lists.xensource.com>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>,
        Peter Zijlstra <peterz@infradead.org>
Subject: Re: linux-next: manual merge of the xen tree with the tip tree
References: <20110825142450.c84e02d8763cfd1a93411844@canb.auug.org.au>
In-Reply-To: <20110825142450.c84e02d8763cfd1a93411844@canb.auug.org.au>
X-Enigmail-Version: 1.3.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/24/2011 09:24 PM, Stephen Rothwell wrote:
> Hi all,
>
> Today's linux-next merge of the xen tree got a conflict in
> arch/x86/include/asm/spinlock.h between a series of commits from the tip
> tree and a smaller series of similar commits from the xen tree.
>
> I see that Linus is commenting on these patches at the moment, and its
> not easy to resolve the conflicts, so I will just use the xen tree from
> next-20110824 for today.
>

Thanks Stephen; the xen tree ones are more current, and I want to make
sure I didn't screw up any of the cmpxchg/xadd changes in a wider test env.

    J

