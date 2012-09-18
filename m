Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757908Ab2IRKTv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Sep 2012 06:19:51 -0400
Received: from cantor2.suse.de ([195.135.220.15]:46822 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757148Ab2IRKTu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Sep 2012 06:19:50 -0400
Date: Tue, 18 Sep 2012 12:19:41 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
To: Tejun Heo <tj@kernel.org>
Cc: "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] x86, apm: Make on_cpu0() use workqueue instead of
 work_on_cpu()
In-Reply-To: <20120917213829.GN18677@google.com>
Message-ID: <alpine.LNX.2.00.1209181219090.31149@pobox.suse.cz>
References: <20120824011134.GB21325@google.com> <alpine.LNX.2.00.1208281557000.22447@pobox.suse.cz> <20120917213829.GN18677@google.com>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 17 Sep 2012, Tejun Heo wrote:

> > > Make APM schedule a work item on CPU0 instead of using the expensive
> > > work_on_cpu(); hopefully, this is the last user of work_on_cpu() and
> > > we can take out work_on_cpu() in not too distant future.
> > > 
> > > Tested both paths.  Seems to work fine.
> > 
> > Applying to apm.git, thanks Tejun.
> 
> It seems we need work_on_cpu() after all and I'm planning on
> reimplementing it in saner way.  Can you please drop this one?

Okay, dropped now.

-- 
Jiri Kosina
SUSE Labs
