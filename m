Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753083Ab0ELGin (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 May 2010 02:38:43 -0400
Received: from mail-pz0-f204.google.com ([209.85.222.204]:37246 "EHLO
	mail-pz0-f204.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751492Ab0ELGil (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 May 2010 02:38:41 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=JXMrfUD1fEb/85XGiuvZYJIrFuyxjpkwlIeSbvzh/bH+4vkiQJEiTtanHl+kNsIBRO
         +XYac41TJugUg2dhlV6oKH1c626SWphufjRBB/DlIAkQ4dsf0kt9L8oYYVeqwC4AuxnC
         QZ1yThUMOQX6alcZwXicJEtWvqal0Oe38DcjU=
Date: Wed, 12 May 2010 14:42:30 +0800
From: =?utf-8?Q?Am=C3=A9rico?= Wang <xiyou.wangcong@gmail.com>
To: Nicolas Palix <npalix@diku.dk>
Cc: Randy Dunlap <rdunlap@xenotime.net>, Roland Dreier <rdreier@cisco.com>,
       Joe Perches <joe@perches.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       "David S. Miller" <davem@davemloft.net>, Michal Marek <mmarek@suse.cz>,
       Sam Ravnborg <sam@ravnborg.org>, Julia Lawall <julia@diku.dk>,
       Gilles Muller <Gilles.Muller@lip6.fr>, linux-kernel@vger.kernel.org,
       linux-kbuild@vger.kernel.org, cocci@diku.dk,
       Wolfram Sang <w.sang@pengutronix.de>,
       Kernel Janitors <kernel-janitors@vger.kernel.org>
Subject: Re: [PATCH 1/4] Add targets to use the Coccinelle checker
Message-ID: <20100512064230.GC5718@cr0.nay.redhat.com>
References: <1273508667-5152-1-git-send-email-npalix@diku.dk>
 <1273508667-5152-2-git-send-email-npalix@diku.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1273508667-5152-2-git-send-email-npalix@diku.dk>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 10, 2010 at 06:24:24PM +0200, Nicolas Palix wrote:
>Four targets are added. Each one generates a different
>output kind: context, patch, org, report.
>Every SmPL file in 'scripts/coccinelle' is given to the spatch frontend
>(located in the 'scripts' directory), and applied to the entire
>source tree.
>
>Signed-off-by: Nicolas Palix <npalix@diku.dk>
>Signed-off-by: Julia Lawall <julia@diku.dk>

Hi,

This is great! I would like to see coccinelle to be integrated with kbuild,
but the name 'coccicheck' is really confusing, how about 'sema_check'? Which
means 'semantic check'.

Or we can use something like for sparse, i.e. 'make C=1' etc..

Thanks!

