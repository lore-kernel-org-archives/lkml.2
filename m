Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752975Ab0EERXT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 May 2010 13:23:19 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:55338 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751254Ab0EERXR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 May 2010 13:23:17 -0400
Date: Wed, 5 May 2010 13:23:16 -0400
From: Christoph Hellwig <hch@infradead.org>
To: Pankaj Thakkar <pthakkar@vmware.com>
Cc: linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
       virtualization@lists.linux-foundation.org, pv-drivers@vmware.com,
       sbhatewara@vmware.com
Subject: Re: RFC: Network Plugin Architecture (NPA) for vmxnet3
Message-ID: <20100505172316.GA25338@infradead.org>
References: <20100504230225.GP8323@vmware.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100504230225.GP8323@vmware.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 04, 2010 at 04:02:25PM -0700, Pankaj Thakkar wrote:
> The plugin image is provided by the IHVs along with the PF driver and is
> packaged in the hypervisor. The plugin image is OS agnostic and can be loaded
> either into a Linux VM or a Windows VM. The plugin is written against the Shell
> API interface which the shell is responsible for implementing. The API

We're not going to add any kind of loader for binry blobs into kernel
space, sorry.  Don't even bother wasting your time on this.

