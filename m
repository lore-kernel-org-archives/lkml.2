Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756687Ab0EFTN6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 May 2010 15:13:58 -0400
Received: from terminus.zytor.com ([198.137.202.10]:49153 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756139Ab0EFTN5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 May 2010 15:13:57 -0400
Message-ID: <4BE314CD.6060701@zytor.com>
Date: Thu, 06 May 2010 12:13:17 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100430 Fedora/3.0.4-2.fc12 Thunderbird/3.0.4
MIME-Version: 1.0
To: Greg KH <greg@kroah.com>
CC: asdf@kroah.com, Thomas Gleixner <tglx@linutronix.de>,
       Ingo Molnar <mingo@redhat.com>, x86@kernel.org,
       linux-kernel@vger.kernel.org, Vadim Rozenfeld <vrozenfe@redhat.com>,
       Avi Kivity <avi@redhat.com>, Gleb Natapov <gleb@redhat.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Haiyang Zhang <haiyangz@microsoft.com>,
       Hank Janssen <hjanssen@microsoft.com>
Subject: Re: [PATCH] x86: detect running on a HyperV system
References: <20100506190841.GA1605@kroah.com>
In-Reply-To: <20100506190841.GA1605@kroah.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/06/2010 12:08 PM, Greg KH wrote:
> 
> x86-maintainers, we need this patch in the tree to get a -staging driver
> to work properly.  If you don't object, can I take it through the
> staging tree?  Or do you want to take it in -tip?
> 

I'd prefer to take it in -tip, partly because I would like to rework a
few things -- including preexisting braindamage like c->x86_hyper_vendor
(since when was hypervisor vendor a per-cpu property!?)

I'll try to get to it today, if not feel free to bug me.

	-hpa

-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

