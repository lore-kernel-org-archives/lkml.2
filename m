Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759450Ab2BNEow (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Feb 2012 23:44:52 -0500
Received: from mail-tul01m020-f174.google.com ([209.85.214.174]:40829 "EHLO
	mail-tul01m020-f174.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759402Ab2BNEoi convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Feb 2012 23:44:38 -0500
MIME-Version: 1.0
In-Reply-To: <20120214153652.7850e2bd7b87e92008c15c4c@canb.auug.org.au>
References: <20120214153652.7850e2bd7b87e92008c15c4c@canb.auug.org.au>
From: Grant Likely <grant.likely@secretlab.ca>
Date: Mon, 13 Feb 2012 21:44:18 -0700
X-Google-Sender-Auth: 8mPF6bWFPqLu0UisTL1HVvefhqA
Message-ID: <CACxGe6uvbyT9Jwg3+nzjF36cSAPqSWOdpKeiPT+JtbeEz5h7tw@mail.gmail.com>
Subject: Re: linux-next: manual merge of the irqdomain tree with Linus' tree
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Russell King <rmk@arm.linux.org.uk>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 13, 2012 at 9:36 PM, Stephen Rothwell <sfr@canb.auug.org.au> wrote:
> Hi Grant,
>
> Today's linux-next merge of the irqdomain tree got a conflict in
> drivers/mfd/twl-core.c between commit 6252547b8a7a ("ARM: omap: fix
> broken twl-core dependencies and ifdefs") from Linus' tree and commit
> 7da5a66bbf1f ("irq_domain: Remove 'new' irq_domain in favour of the ppc
> one") from the irqdomain tree.
>
> The latter removes the code modified by the former, so I did that.

Thanks Stephen. I'll respin the tree after the next rc

g.

> --
> Cheers,
> Stephen Rothwell                    sfr@canb.auug.org.au



-- 
Grant Likely, B.Sc., P.Eng.
Secret Lab Technologies Ltd.
