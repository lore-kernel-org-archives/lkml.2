Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754093Ab2GDOuu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jul 2012 10:50:50 -0400
Received: from casper.infradead.org ([85.118.1.10]:42792 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751458Ab2GDOuo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jul 2012 10:50:44 -0400
Subject: RE: [PATCH] printk: fixing the deadlock when calling printk in nmi
 handle
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: "Liu, Chuansheng" <chuansheng.liu@intel.com>
Cc: "'linux-kernel@vger.kernel.org' (linux-kernel@vger.kernel.org)" 
	<linux-kernel@vger.kernel.org>,
        "kay@vrfy.org" <kay@vrfy.org>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "mingo@elte.hu" <mingo@elte.hu>
In-Reply-To: <27240C0AC20F114CBF8149A2696CBE4A10CA93@SHSMSX101.ccr.corp.intel.com>
References: <27240C0AC20F114CBF8149A2696CBE4A10C7F6@SHSMSX101.ccr.corp.intel.com>
	 <1341408169.2507.111.camel@laptop>
	 <27240C0AC20F114CBF8149A2696CBE4A10C84B@SHSMSX101.ccr.corp.intel.com>
	 <1341409177.2507.117.camel@laptop>
	 <27240C0AC20F114CBF8149A2696CBE4A10CA93@SHSMSX101.ccr.corp.intel.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 04 Jul 2012 16:50:31 +0200
Message-ID: <1341413431.2507.124.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2012-07-04 at 14:46 +0000, Liu, Chuansheng wrote:
> > > I took many time to dig out this issue.
> > 
> > Well, it was a known issue..
> Still feel unfair :)
> If this is a known issue that calling printk is not safe in nmi handler,
> Why not defense it like this patch before real solution coming out?

Why replace one broken thing with another broken thing?

