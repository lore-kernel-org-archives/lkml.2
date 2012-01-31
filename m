Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751913Ab2AaFPp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Jan 2012 00:15:45 -0500
Received: from out3-smtp.messagingengine.com ([66.111.4.27]:39322 "EHLO
	out3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751071Ab2AaFPn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Jan 2012 00:15:43 -0500
X-Sasl-enc: 3gAOtMXjxi75EdPlni/rMoxIfy7UN00fm4a0Go7Q0Tqr 1327986942
Date: Mon, 30 Jan 2012 21:14:42 -0800
From: Greg KH <greg@kroah.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Mark Allyn <mark.a.allyn@intel.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Alan Cox <alan@linux.intel.com>
Subject: Re: linux-next: build warnings after merge of the staging tree
Message-ID: <20120131051442.GA25054@kroah.com>
References: <20120131142521.852ecb04b07f7174c179b3c8@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120131142521.852ecb04b07f7174c179b3c8@canb.auug.org.au>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 31, 2012 at 02:25:21PM +1100, Stephen Rothwell wrote:
> Hi Greg,
> 
> After merging the staging tree, today's linux-next build (x86_64
> allmodconfig) produced these warnings:
> 
> drivers/staging/sep/sep_main.c: In function 'sep_allocate_dmatables_region':
> drivers/staging/sep/sep_main.c:217:2: warning: format '%X' expects argument of type 'unsigned int', but argument 5 has type 'size_t' [-Wformat]
> drivers/staging/sep/sep_main.c: In function 'sep_activate_msgarea_context':
> drivers/staging/sep/sep_main.c:3348:5: warning: format '%X' expects argument of type 'unsigned int', but argument 4 has type 'size_t' [-Wformat]
> drivers/staging/sep/sep_main.c: In function 'sep_create_msgarea_context':
> drivers/staging/sep/sep_main.c:3380:5: warning: format '%X' expects argument of type 'unsigned int', but argument 4 has type 'size_t' [-Wformat]
> drivers/staging/sep/sep_main.c: In function 'sep_read':
> drivers/staging/sep/sep_main.c:3466:2: warning: format '%X' expects argument of type 'unsigned int', but argument 5 has type 'size_t' [-Wformat]
> drivers/staging/sep/sep_main.c: In function 'sep_fastcall_args_get':
> drivers/staging/sep/sep_main.c:3526:5: warning: format '%X' expects argument of type 'unsigned int', but argument 4 has type 'size_t' [-Wformat]
> drivers/staging/sep/sep_main.c:3567:5: warning: format '%X' expects argument of type 'unsigned int', but argument 4 has type 'size_t' [-Wformat]
> drivers/staging/sep/sep_main.c:3567:5: warning: format '%X' expects argument of type 'unsigned int', but argument 5 has type 'size_t' [-Wformat]
> 
> Introduced by commit ff3d9c3c90c6 ("staging: sep: SEP update").

Thanks, I've already told Alan about them, he said he would resolve them
soon.

greg k-h
