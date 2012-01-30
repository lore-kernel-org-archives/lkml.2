Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753447Ab2A3V1l (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jan 2012 16:27:41 -0500
Received: from out3-smtp.messagingengine.com ([66.111.4.27]:39759 "EHLO
	out3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751975Ab2A3V1k (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jan 2012 16:27:40 -0500
X-Sasl-enc: N6EF6ueF+sEQQjRfXLgzWN4o7bpPEgiXZiQGkJLs0CcS 1327958859
Date: Mon, 30 Jan 2012 13:26:45 -0800
From: Greg KH <greg@kroah.com>
To: Andi Kleen <ak@linux.intel.com>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] cpufreq/gx: Fix the compile error
Message-ID: <20120130212645.GA13988@kroah.com>
References: <20120130144720.5908.37381.stgit@bob.linux.org.uk>
 <4F2706AE.8020801@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4F2706AE.8020801@linux.intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 30, 2012 at 01:07:58PM -0800, Andi Kleen wrote:
> On 1/30/2012 6:47 AM, Alan Cox wrote:
> >From: Alan Cox<alan@linux.intel.com>
> >
> >Someone forgot to test this one it seems.
> 
> Sorry about that
> Thanks. Greg can you please add it to the cpuid probe patchkit?

Will do, thanks for pointing it out to me, I would have missed it.

greg k-h
