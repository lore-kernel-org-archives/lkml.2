Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756612Ab1KNXRm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Nov 2011 18:17:42 -0500
Received: from mail-fx0-f46.google.com ([209.85.161.46]:35552 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753827Ab1KNXRk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Nov 2011 18:17:40 -0500
MIME-Version: 1.0
In-Reply-To: <201111150014.50898.rjw@sisk.pl>
References: <20111114131730.ae09bb18b87e67f61a97275e@canb.auug.org.au>
	<201111150014.50898.rjw@sisk.pl>
Date: Mon, 14 Nov 2011 15:17:38 -0800
X-Google-Sender-Auth: ZfEjuCyD-f7L6tDOQ-jeNWBWL-w
Message-ID: <CAOS58YPgU+z2riUj5y--pj55PnHzqkj_on1vxW3VBy=FDkJuqQ@mail.gmail.com>
Subject: Re: linux-next: build failure after merge of the pm tree (and warning)
From: Tejun Heo <tj@kernel.org>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
        Vinod Koul <vinod.koul@intel.com>,
        Nicolas Ferre <nicolas.ferre@atmel.com>,
        Dan Williams <dan.j.williams@intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

2011/11/14 Rafael J. Wysocki <rjw@sisk.pl>:
> Thanks, I've added the following patch to linux-pm/linux-next, which should
> fix this problem (Tejun, if that's not the right thing to do, please let me
> know).

Working on a proper fix now.

Thanks.

-- 
tejun
