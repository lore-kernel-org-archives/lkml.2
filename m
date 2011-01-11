Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755384Ab1AKDsx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Jan 2011 22:48:53 -0500
Received: from smtp-out.google.com ([216.239.44.51]:34353 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755361Ab1AKDsn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Jan 2011 22:48:43 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id
         :references:user-agent:mime-version:content-type;
        b=nXLbLYxa3cobHlImGs9q0O3+2PIUu8TKQjPXhRr3SSANDFQxruOxVJCEP1bUBXeuKr
         oBUyavKrn4coxTJq/7vA==
Date: Mon, 10 Jan 2011 19:48:37 -0800 (PST)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Tejun Heo <tj@kernel.org>
cc: linux-kernel@vger.kernel.org, mingo@redhat.com, tglx@linutronix.de,
        hpa@zytor.com, x86@kernel.org, eric.dumazet@gmail.com,
        yinghai@kernel.org, brgerst@gmail.com, gorcunov@gmail.com,
        penberg@kernel.org, shaohui.zheng@intel.com
Subject: Re: [PATCH 03/16] x86: Make default_send_IPI_mask_sequence/allbutself_logical()
 32bit only
In-Reply-To: <1293731369-10851-4-git-send-email-tj@kernel.org>
Message-ID: <alpine.DEB.2.00.1101101934580.31039@chino.kir.corp.google.com>
References: <1293731369-10851-1-git-send-email-tj@kernel.org> <1293731369-10851-4-git-send-email-tj@kernel.org>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 30 Dec 2010, Tejun Heo wrote:

> Both functions are used only in 32bit.  Put them inside CONFIG_X86_32.
> This is to prepare for logical apicid handling update.
> 
> - Cyrill Gorcunov spotted that I forgot to move declarations in ipi.h
>   under CONFIG_X86_32.  Fixed.
> 
> Signed-off-by: Tejun Heo <tj@kernel.org>
> Reviewed-by: Pekka Enberg <penberg@kernel.org>
> Reviewed-by: Cyrill Gorcunov <gorcunov@gmail.com>

Acked-by: David Rientjes <rientjes@google.com>
