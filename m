Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756536Ab2FNSlb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jun 2012 14:41:31 -0400
Received: from terminus.zytor.com ([198.137.202.10]:37255 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753999Ab2FNSla (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jun 2012 14:41:30 -0400
Message-ID: <4FDA304C.4050306@zytor.com>
Date: Thu, 14 Jun 2012 11:41:16 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:12.0) Gecko/20120430 Thunderbird/12.0.1
MIME-Version: 1.0
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
CC: David Vrabel <david.vrabel@citrix.com>, rusty@rustcorp.com.au,
        "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>,
        "x86@kernel.org" <x86@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 0/2] x86/mm: remove arch-specific PTE/PMD get-and-clear
 functions
References: <1339582845-25659-1-git-send-email-david.vrabel@citrix.com> <20120613140404.GH5979@phenom.dumpdata.com> <4FD8AB07.7080004@citrix.com> <20120614182913.GA21956@phenom.dumpdata.com>
In-Reply-To: <20120614182913.GA21956@phenom.dumpdata.com>
X-Enigmail-Version: 1.4.1
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/14/2012 11:29 AM, Konrad Rzeszutek Wilk wrote:
> 
> Lets rope Rusty in this since he is the maintainer of lguest.
>

Also, let's have realistic expectations for lguest.

I don't want to break lguest just for sh*ts and giggles, but if lguest
is in the way of making forward progress for other things, it would have
to have a very strong case to not be sacrificed.

	-hpa


-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

