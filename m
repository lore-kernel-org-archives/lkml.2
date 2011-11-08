Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753717Ab1KHI0r (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Nov 2011 03:26:47 -0500
Received: from manchmal.in-ulm.de ([217.10.9.201]:51519 "EHLO
	manchmal.in-ulm.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753307Ab1KHI0p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Nov 2011 03:26:45 -0500
Date: Tue, 8 Nov 2011 09:26:42 +0100
From: Christoph Biedl <linux-kernel.bfrz@manchmal.in-ulm.de>
To: Ian Campbell <Ian.Campbell@citrix.com>
Cc: Greg KH <gregkh@suse.de>, Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Jeremy Fitzhardinge <Jeremy.Fitzhardinge@citrix.com>,
        linux-kernel@vger.kernel.org, stable@kernel.org
Subject: Re: Linux 2.6.32.47
Message-ID: <1320739843@msgid.manchmal.in-ulm.de>
References: <20111107213431.GA8483@kroah.com>
 <1320708564@msgid.manchmal.in-ulm.de>
 <20111108003024.GA6610@suse.de>
 <1320736973.16747.55.camel@dagon.hellion.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1320736973.16747.55.camel@dagon.hellion.org.uk>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ian Campbell wrote...

> From: Ian Campbell <ian.campbell@citrix.com>
> Date: Tue, 8 Nov 2011 07:19:06 +0000
> Subject: [PATCH] irq: fix build error due to missing irq_pm_syscore_resume

Thanks, works for me. Kernel compiles, new kernel is running.

    Christoph
