Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755545Ab0DIJJA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Apr 2010 05:09:00 -0400
Received: from 8bytes.org ([88.198.83.132]:44366 "EHLO 8bytes.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751958Ab0DIJI5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Apr 2010 05:08:57 -0400
Date: Fri, 9 Apr 2010 11:08:55 +0200
From: Joerg Roedel <joro@8bytes.org>
To: Tom Lyon <pugs@lyon-about.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, mst@redhat.com
Subject: Re: [PATCH 1/1] uio_pci_generic: extensions to allow access for
	non-privileged processes
Message-ID: <20100409090855.GF8750@8bytes.org>
References: <201003311708.38961.pugs@lyon-about.com> <201003311712.36105.pugs@lyon-about.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201003311712.36105.pugs@lyon-about.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Btw. This patch posting is broken. It suffers from line-wraps which make
it impossible to apply as-is. I was able to fix it but please consider
this in your next posting.

On Wed, Mar 31, 2010 at 05:12:35PM -0700, Tom Lyon wrote:

> --- linux-2.6.33/drivers/uio/uio_pci_generic.c	2010-02-24 
> 10:52:17.000000000 -0800
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
Unexpected line-wrap.

I also got some whitespace warnings when trying to apply it. Please make
sure you fix this in the next version too.

Thanks,

	Joerg

