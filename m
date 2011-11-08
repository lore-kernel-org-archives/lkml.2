Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754035Ab1KHIdJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Nov 2011 03:33:09 -0500
Received: from smtp.eu.citrix.com ([62.200.22.115]:43977 "EHLO
	SMTP.EU.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753682Ab1KHIdH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Nov 2011 03:33:07 -0500
X-IronPort-AV: E=Sophos;i="4.69,476,1315180800"; 
   d="scan'208";a="8808959"
Subject: Re: Linux 2.6.32.47
From: Ian Campbell <Ian.Campbell@citrix.com>
To: Christoph Biedl <linux-kernel.bfrz@manchmal.in-ulm.de>
CC: Greg KH <gregkh@suse.de>, Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Jeremy Fitzhardinge <Jeremy.Fitzhardinge@citrix.com>,
        linux-kernel@vger.kernel.org, stable@kernel.org
In-Reply-To: <1320739843@msgid.manchmal.in-ulm.de>
References: <20111107213431.GA8483@kroah.com>
	 <1320708564@msgid.manchmal.in-ulm.de> <20111108003024.GA6610@suse.de>
	 <1320736973.16747.55.camel@dagon.hellion.org.uk>
	 <1320739843@msgid.manchmal.in-ulm.de>
Content-Type: text/plain; charset="ISO-8859-1"
Organization: Citrix Systems, Inc.
Date: Tue, 8 Nov 2011 08:33:04 +0000
Message-ID: <1320741185.16747.64.camel@dagon.hellion.org.uk>
MIME-Version: 1.0
X-Mailer: Evolution 2.32.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-11-08 at 09:26 +0100, Christoph Biedl wrote:
> Ian Campbell wrote...
> 
> > From: Ian Campbell <ian.campbell@citrix.com>
> > Date: Tue, 8 Nov 2011 07:19:06 +0000
> > Subject: [PATCH] irq: fix build error due to missing irq_pm_syscore_resume
> 
> Thanks, works for me. Kernel compiles, new kernel is running.

Great, thanks for reporting/testing.

Ian.


