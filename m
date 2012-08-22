Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753125Ab2HVRiA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Aug 2012 13:38:00 -0400
Received: from mail-wg0-f44.google.com ([74.125.82.44]:47173 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751692Ab2HVRh5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Aug 2012 13:37:57 -0400
Date: Wed, 22 Aug 2012 19:37:52 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Ido Yariv <ido@wizery.com>
Cc: linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        "H. Peter Anvin" <hpa@zytor.com>, Shai Fultheim <shai@scalemp.com>
Subject: Re: [PATCH v2] x86/vsmp: Use hypervisor layer for initialization
Message-ID: <20120822173752.GA32500@gmail.com>
References: <20120822100845.GB26323@gmail.com>
 <1345634411-28108-1-git-send-email-ido@wizery.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1345634411-28108-1-git-send-email-ido@wizery.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Ido Yariv <ido@wizery.com> wrote:

> +#ifdef CONFIG_X86_64
> +	&x86_hyper_vsmp,
> +#endif

Why doesn't it all depend on CONFIG_X86_VSMP?

Thanks,

	Ingo
