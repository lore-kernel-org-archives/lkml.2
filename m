Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754796Ab2DCTsT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Apr 2012 15:48:19 -0400
Received: from usmamail.tilera.com ([206.83.70.75]:14771 "EHLO
	USMAMAIL.TILERA.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753423Ab2DCTsR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Apr 2012 15:48:17 -0400
Message-ID: <4F7B53FC.7030606@tilera.com>
Date: Tue, 3 Apr 2012 15:48:12 -0400
From: Chris Metcalf <cmetcalf@tilera.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:11.0) Gecko/20120327 Thunderbird/11.0.1
MIME-Version: 1.0
To: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
CC: <rkuo@codeaurora.org>, <tglx@linutronix.de>, <linas@codeaurora.org>,
        <mingo@elte.hu>, <a.p.zijlstra@chello.nl>, <dhowells@redhat.com>,
        <yasutake.koichi@jp.panasonic.com>, <akpm@linux-foundation.org>,
        <benh@kernel.crashing.org>, <jesper.nilsson@axis.com>,
        <linux@arm.linux.org.uk>, <jejb@parisc-linux.org>, <deller@gmx.de>,
        <vapier@gentoo.org>, <linux-hexagon@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <linux-am33-list@redhat.com>,
        <linux-parisc@vger.kernel.org>
Subject: Re: [PATCH 4/4] tile/CPU hotplug: Add missing call to notify_cpu_starting()
References: <20120322112735.17063.21791.stgit@srivatsabhat.in.ibm.com> <20120322112905.17063.88829.stgit@srivatsabhat.in.ibm.com>
In-Reply-To: <20120322112905.17063.88829.stgit@srivatsabhat.in.ibm.com>
X-Enigmail-Version: 1.4
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 3/22/2012 7:29 AM, Srivatsa S. Bhat wrote:
> The scheduler depends on receiving the CPU_STARTING notification, without
> which we end up into a lot of trouble. So add the missing call to
> notify_cpu_starting() in the bringup code.
>
> Signed-off-by: Srivatsa S. Bhat <srivatsa.bhat@linux.vnet.ibm.com>
> ---
>
>  arch/tile/kernel/smpboot.c |    2 ++
>  1 files changed, 2 insertions(+), 0 deletions(-)

Thanks!  Taken into the tile tree.

-- 
Chris Metcalf, Tilera Corp.
http://www.tilera.com

