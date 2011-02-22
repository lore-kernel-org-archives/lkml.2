Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752200Ab1BVA2G (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Feb 2011 19:28:06 -0500
Received: from smtp-out.google.com ([74.125.121.67]:50025 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751104Ab1BVA2E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Feb 2011 19:28:04 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id
         :references:user-agent:mime-version:content-type;
        b=kIK9zmiP4EFivQeOfU/yGaAsl3iOuoCg7lAm8btlYMGFKBR0jxysViAPWqZn0Dj/4e
         5bvVZbsFhbuNBUnGDvjg==
Date: Mon, 21 Feb 2011 16:27:57 -0800 (PST)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Yinghai Lu <yinghai@kernel.org>
cc: Tejun Heo <tj@kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Cyrill Gorcunov <gorcunov@gmail.com>
Subject: Re: [PATCH 2/4] x86, numa: Do not adjust start/end for
 early_node_mem()
In-Reply-To: <4D629F17.5030006@kernel.org>
Message-ID: <alpine.DEB.2.00.1102211627450.23557@chino.kir.corp.google.com>
References: <4D5EC05A.60103@kernel.org> <4D5EC184.6000505@kernel.org> <alpine.DEB.2.00.1102191944530.32280@chino.kir.corp.google.com> <AANLkTikgR8vEhz3Hsmx96QqZw_gsLZetc3W_9evf3ufb@mail.gmail.com> <20110221094318.GG31267@htj.dyndns.org>
 <4D629F17.5030006@kernel.org>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 21 Feb 2011, Yinghai Lu wrote:

> [PATCH] x86, numa, 64bit: Do not adjust start/end at first for early_node_mem()
> 
> We have top-down allocation  with memblock way now.
> So do not need to adjust start/end to make them above DMA region.
> memblock allocation always get high address for us.
> 
> Just remove those lines.
> 
> Signed-off-by: Yinghai Lu <yinghai@kernel.org>

Acked-by: David Rientjes <rientjes@google.com>
