Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752453Ab2B0IB7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Feb 2012 03:01:59 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:40401 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751054Ab2B0IB6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Feb 2012 03:01:58 -0500
Date: Mon, 27 Feb 2012 00:03:10 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: Mike Travis <travis@sgi.com>, David Woodhouse <dwmw2@infradead.org>,
        Chris Wright <chrisw@sous-sol.org>, Daniel Rahn <drahn@suse.com>,
        Jesse Barnes <jbarnes@virtuousgeek.org>,
        Jack Steiner <steiner@sgi.com>, Tony Ernst <tee@sgi.com>,
        x86@kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] x86, pci: Increase the number of iommus supported
 to be MAX_IO_APICS v2
Message-Id: <20120227000310.a7e36dd9.akpm@linux-foundation.org>
In-Reply-To: <20120227075741.GD3397@elte.hu>
References: <20120223004930.817124691@gulag1.americas.sgi.com>
	<20120223004931.121722197@gulag1.americas.sgi.com>
	<20120223123011.cfe4ae35.akpm@linux-foundation.org>
	<20120227075741.GD3397@elte.hu>
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.18.9; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 27 Feb 2012 08:57:41 +0100 Ingo Molnar <mingo@elte.hu> wrote:

> * Andrew Morton <akpm@linux-foundation.org> wrote:
> 
> > Also we can tweak the code flow and the message to avoid dorky
> > 80-column games:
> 
> > +		printk_once(KERN_ERR "intel-iommu: exceeded %d IOMMUs\n",
> >  			  IOMMU_UNITS_SUPPORTED);
> 
> Not to mention the use of pr_err():
> 
> 		pr_err("intel-iommu: exceeded %d IOMMUs\n", IOMMU_UNITS_SUPPORTED);

Where's my pr_err_once() ;)
