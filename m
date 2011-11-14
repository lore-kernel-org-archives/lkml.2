Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756637Ab1KNXV2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Nov 2011 18:21:28 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:39416 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752638Ab1KNXV0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Nov 2011 18:21:26 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Tejun Heo <tj@kernel.org>
Subject: Re: linux-next: build failure after merge of the pm tree (and warning)
Date: Tue, 15 Nov 2011 00:24:06 +0100
User-Agent: KMail/1.13.6 (Linux/3.1.0-rc10+; KDE/4.6.0; x86_64; ; )
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
        Vinod Koul <vinod.koul@intel.com>,
        Nicolas Ferre <nicolas.ferre@atmel.com>,
        Dan Williams <dan.j.williams@intel.com>
References: <20111114131730.ae09bb18b87e67f61a97275e@canb.auug.org.au> <201111150014.50898.rjw@sisk.pl> <CAOS58YPgU+z2riUj5y--pj55PnHzqkj_on1vxW3VBy=FDkJuqQ@mail.gmail.com>
In-Reply-To: <CAOS58YPgU+z2riUj5y--pj55PnHzqkj_on1vxW3VBy=FDkJuqQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201111150024.06719.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, November 15, 2011, Tejun Heo wrote:
> Hello,
> 
> 2011/11/14 Rafael J. Wysocki <rjw@sisk.pl>:
> > Thanks, I've added the following patch to linux-pm/linux-next, which should
> > fix this problem (Tejun, if that's not the right thing to do, please let me
> > know).
> 
> Working on a proper fix now.

OK, thanks!

Rafael
