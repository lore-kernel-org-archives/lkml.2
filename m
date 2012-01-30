Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753406Ab2A3SZH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jan 2012 13:25:07 -0500
Received: from acsinet15.oracle.com ([141.146.126.227]:58910 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753341Ab2A3SZF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jan 2012 13:25:05 -0500
Date: Mon, 30 Jan 2012 13:22:30 -0500
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: David Miller <davem@davemloft.net>
Cc: shemminger@vyatta.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: Regression in skge that started around acb42a3 (so past v3.3-rc1)
Message-ID: <20120130182230.GA4122@phenom.dumpdata.com>
References: <20120130155816.GA1400@phenom.dumpdata.com>
 <20120130083843.160ffe5e@nehalam.linuxnetplumber.net>
 <20120130175738.GA4002@phenom.dumpdata.com>
 <20120130.130259.1190745234966440677.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120130.130259.1190745234966440677.davem@davemloft.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
X-CT-RefId: str=0001.0A090208.4F26E07F.0091,ss=1,re=0.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 30, 2012 at 01:02:59PM -0500, David Miller wrote:
> From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
> Date: Mon, 30 Jan 2012 12:57:38 -0500
> 
> > Ah, so you are saying that the problem above is already fixed in 3.3-rc1.
> 
> No he's not saying that, he says somewhere we probably need a fix
> "like" the commit he mentioned.
> 
> He did not say that commit fixes this bug.

Ayee. Sounds you guys have an idea about this bug then. If you want me to run
a test-patch I can certainly do so. Thanks!
