Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754026Ab1KVTRv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Nov 2011 14:17:51 -0500
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:35386 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750884Ab1KVTRu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Nov 2011 14:17:50 -0500
Date: Tue, 22 Nov 2011 19:17:29 +0000
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: "kautuk.c @samsung.com" <consul.kautuk@gmail.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will.deacon@arm.com>, Ingo Molnar <mingo@elte.hu>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/1 v5] arm: fault.c: Port OOM changes into
	do_page_fault
Message-ID: <20111122191729.GA9581@n2100.arm.linux.org.uk>
References: <1321985779-5810-1-git-send-email-consul.kautuk@gmail.com> <CAFPAmTQ3su_tuwHEBKPwn4YFX8sWs0x1agYfyzTnOdBaVRL21Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAFPAmTQ3su_tuwHEBKPwn4YFX8sWs0x1agYfyzTnOdBaVRL21Q@mail.gmail.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 22, 2011 at 01:33:42PM -0500, kautuk.c @samsung.com wrote:
> Please disregard this one due to the following line :
> From: Kautuk <kautuk@ubuntu.(none)>
> 
> There was something wrong in my git configuration.

Which is the correct one?  The first?
