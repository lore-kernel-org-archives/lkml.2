Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759630Ab0FPUkY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jun 2010 16:40:24 -0400
Received: from [18.85.46.34] ([18.85.46.34]:54040 "EHLO bombadil.infradead.org"
	rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1759605Ab0FPUkW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jun 2010 16:40:22 -0400
Date: Wed, 16 Jun 2010 16:40:19 -0400
From: Kyle McMartin <kyle@mcmartin.ca>
To: David Miller <davem@davemloft.net>
Cc: kyle@mcmartin.ca, vst@vlnb.net, sparclinux@vger.kernel.org,
       simone.ricci@gmail.com, scst-devel@lists.sourceforge.net,
       linux-kernel@vger.kernel.org, Nick.Couchman@seakr.com
Subject: Re: Error "Unknown relocation: 36" on module load on Sparc
Message-ID: <20100616204019.GY20317@bombadil.infradead.org>
References: <AANLkTimuv7nOlcGFxqPZlwcAjLmFMiLAvbA5O7F32Wbg@mail.gmail.com> <4C192085.2090404@vlnb.net> <20100616192257.GW20317@bombadil.infradead.org> <20100616.133854.183053376.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100616.133854.183053376.davem@davemloft.net>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 16, 2010 at 01:38:54PM -0700, David Miller wrote:
> This change is incorrect.
> 
> LM22 relocations do not get emitted for the "medlow" code model, which
> is what is explicitly specified on the kernel compiler command line
> for sparc64 via "-mcmodel=medlow".
> 
> Someone this person is using incorrect CFLAGS when building their
> module, and that's why they have this problem, because the compiler's
> default code model on sparc64 can generate those relocations.
>

Yeah, just saw your other mail. Thanks for the explanation!

--Kyle
