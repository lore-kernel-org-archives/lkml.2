Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753913Ab3AJMBY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jan 2013 07:01:24 -0500
Received: from mail.skyhub.de ([78.46.96.112]:60394 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750984Ab3AJMBW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jan 2013 07:01:22 -0500
Date: Thu, 10 Jan 2013 13:01:21 +0100
From: Borislav Petkov <bp@alien8.de>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: netfilter-devel@vger.kernel.org, netfilter@vger.kernel.org,
        coreteam@netfilter.org, lkml <linux-kernel@vger.kernel.org>
Subject: Re: v3.8-rc3: uninitialized warnings in net/netfilter/xt_CT.c
Message-ID: <20130110120121.GD23008@liondog.tnic>
Mail-Followup-To: Borislav Petkov <bp@alien8.de>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	netfilter-devel@vger.kernel.org, netfilter@vger.kernel.org,
	coreteam@netfilter.org, lkml <linux-kernel@vger.kernel.org>
References: <20130110111821.GA23008@liondog.tnic>
 <20130110114742.GA17883@1984>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20130110114742.GA17883@1984>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 10, 2013 at 12:47:42PM +0100, Pablo Neira Ayuso wrote:
> Patch attached to address this issue.

> From 3ceaa3b1baa660aaeef63b86ea9771dcab6d0acd Mon Sep 17 00:00:00 2001
> From: Pablo Neira Ayuso <pablo@netfilter.org>
> Date: Thu, 10 Jan 2013 12:42:15 +0100
> Subject: [PATCH] netfilter: xt_CT: fix unset return value if conntrack zone
>  are disabled
> MIME-Version: 1.0
> Content-Type: text/plain; charset=UTF-8
> Content-Transfer-Encoding: 8bit
> 
> net/netfilter/xt_CT.c: In function ‘xt_ct_tg_check_v1’:
> net/netfilter/xt_CT.c:250:6: warning: ‘ret’ may be used uninitialized in this function [-Wmaybe-uninitialized]
> net/netfilter/xt_CT.c: In function ‘xt_ct_tg_check_v0’:
> net/netfilter/xt_CT.c:112:6: warning: ‘ret’ may be used uninitialized in this function [-Wmaybe-uninitialized]
> 
> Reported-by: Borislav Petkov <bp@alien8.de>
> Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>

Yep, that's exactly what I meant, thanks Pablo.

Acked-by: Borislav Petkov <bp@alien8.de>

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
