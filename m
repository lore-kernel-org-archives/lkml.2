Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754299Ab1LUXbG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Dec 2011 18:31:06 -0500
Received: from out4.smtp.messagingengine.com ([66.111.4.28]:41370 "EHLO
	out4.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752324Ab1LUXbF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Dec 2011 18:31:05 -0500
X-Sasl-enc: 4xjglBTJlbWsp6QCLlzTFiDUv2keZ2rt7KhdJbltFZrw 1324510263
Date: Wed, 21 Dec 2011 15:29:34 -0800
From: Greg KH <greg@kroah.com>
To: Kay Sievers <kay.sievers@vrfy.org>
Cc: Thomas Renninger <trenn@suse.de>, Andi Kleen <andi@firstfloor.org>,
        linux-kernel@vger.kernel.org, hpa@zytor.com,
        Andi Kleen <ak@linux.intel.com>, axboe@kernel.dk,
        herbert@gondor.hengli.com.au, ying.huang@intel.com, lenb@kernel.org
Subject: Re: [PATCH 9/8] CPU: Introduce ARCH_HAS_CPU_AUTOPROBE and X86 parts
Message-ID: <20111221232934.GC23559@kroah.com>
References: <1324338394-4670-1-git-send-email-andi@firstfloor.org>
 <1324338394-4670-9-git-send-email-andi@firstfloor.org>
 <201112211602.26845.trenn@suse.de>
 <CAPXgP12xDOjaEoRDdjYSSoLFCmpUOCZjoLFuyZHdnEMVsKGa0w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAPXgP12xDOjaEoRDdjYSSoLFCmpUOCZjoLFuyZHdnEMVsKGa0w@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 21, 2011 at 04:32:28PM +0100, Kay Sievers wrote:
> 2011/12/21 Thomas Renninger <trenn@suse.de>:
> 
> Cool. That sounds good. Nice work. Thanks.
> 
> Adding Greg, so he's in the loop.
> 
> Greg, Andi's upcoming CPU modaliases are temporarily hooked into the
> 'cpuid' class devices to make them work with userspace, which isn't
> possible with the weird sysdev stuff.
> 
> We don't want to depend on the 'cpuid' class, but hook into the real
> 'cpu' subsystem. This switches them over after we have the
> sysdev-cpu-conversion stuff merged.

Ok, but what does this mean now for my tree as I've taken your patches?

confused,

greg k-h
