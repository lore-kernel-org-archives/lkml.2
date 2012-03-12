Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756724Ab2CLT25 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Mar 2012 15:28:57 -0400
Received: from smtp27.mail.ru ([94.100.176.180]:45794 "EHLO smtp27.mail.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755891Ab2CLT24 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Mar 2012 15:28:56 -0400
Date: Mon, 12 Mar 2012 23:30:21 +0400
From: Dmitry Artamonow <mad_soft@inbox.ru>
To: Stephen Warren <swarren@wwwdotorg.org>, Olof Johansson <olof@lixom.net>
Cc: linux-tegra@vger.kernel.org, Andi <andi.shyti@gmail.com>,
        Thierry Reding <thierry.reding@avionic-design.de>,
        linux-kernel@vger.kernel.org, Colin Cross <ccross@android.com>,
        Mike Rapoport <mike@compulab.co.il>,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH v2 2/2] arm/tegra: add timeout to PCIe PLL lock detection
 loop
Message-ID: <20120312193020.GA1584@rainbow>
References: <20120306201538.GA14350@rainbow>
 <1331287760-10546-1-git-send-email-mad_soft@inbox.ru>
 <4F5E3BE7.4080207@wwwdotorg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4F5E3BE7.4080207@wwwdotorg.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Spam: Not detected
X-Mras: Ok
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12:09 Mon 12 Mar     , Stephen Warren wrote:
> Thierry pointed out that one of NVIDIA's downstream kernels uses a
> timeout of 300 here, rather than 2000 above. Do you see a specific need
> for this timeout for be 2000 rather than 300? It might be nice to be
> consistent.
No, there's no specific need for it to be 2000 - it may as well be 300.
I just wanted to stay on the safe side, but I think 300 should be still
more than enough time for PLL to lock.

> 
> Olof, I notice you've already applied V1 of this, which has the return
> statement issue. Can you replace it with this, or should Dmitry send an
> incremental patch?

Yes, V1 breaks more things than it fixes, so it would be nice if
it can be replaced with fixed version (I hope it's not too late yet).
BTW, regarding timeout discussion above - should I resend patch with
adjusted timeout, or can you change it while applying? (of course,
if we settle on incremental patch, I'll roll this change in)

-- 
Best regards,
Dmitry "MAD" Artamonow

