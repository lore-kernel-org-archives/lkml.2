Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759330Ab2JKUtL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Oct 2012 16:49:11 -0400
Received: from ozlabs.org ([203.10.76.45]:54469 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754759Ab2JKUtJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Oct 2012 16:49:09 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: Wei Yongjun <weiyj.lk@gmail.com>, mst@redhat.com
Cc: yongjun_wei@trendmicro.com.cn, virtualization@lists.linux-foundation.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] virtio-pci: use module_pci_driver to simplify the code
In-Reply-To: <CAPgLHd-GzSDQ+E-zboLA8RfbOVk5bHFK+NTDe2WkWihVFVCtmA@mail.gmail.com>
References: <CAPgLHd-GzSDQ+E-zboLA8RfbOVk5bHFK+NTDe2WkWihVFVCtmA@mail.gmail.com>
User-Agent: Notmuch/0.13.2 (http://notmuchmail.org) Emacs/23.3.1 (i686-pc-linux-gnu)
Date: Thu, 11 Oct 2012 19:02:50 +1030
Message-ID: <87ipah76j1.fsf@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Wei Yongjun <weiyj.lk@gmail.com> writes:

> From: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
>
> Use the module_pci_driver() macro to make the code simpler
> by eliminating module_init and module_exit calls.
>
> dpatch engine is used to auto generate this patch.
> (https://github.com/weiyj/dpatch)
>
> Signed-off-by: Wei Yongjun <yongjun_wei@trendmicro.com.cn>

Thanks, applied!
Rusty.
