Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932739Ab1AMCk3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Jan 2011 21:40:29 -0500
Received: from smtp-out.google.com ([74.125.121.67]:30577 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932538Ab1AMCkY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Jan 2011 21:40:24 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id
         :references:user-agent:mime-version:content-type;
        b=mhR5XNxwAP9u4wxDoh/h+9fZ58EMXT0u/d4HVAU2Zgpd1VGZxDmT3iGmgCbARnntN/
         u04ldPtuSeQ8AJH/oYsQ==
Date: Wed, 12 Jan 2011 18:40:18 -0800 (PST)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Tejun Heo <tj@kernel.org>
cc: linux-kernel@vger.kernel.org, mingo@redhat.com, tglx@linutronix.de,
        hpa@zytor.com, x86@kernel.org, eric.dumazet@gmail.com,
        yinghai@kernel.org, brgerst@gmail.com, gorcunov@gmail.com,
        penberg@kernel.org, shaohui.zheng@intel.com
Subject: Re: [PATCH 06/16] x86: Kill apic->cpu_to_logical_apicid()
In-Reply-To: <1293731369-10851-7-git-send-email-tj@kernel.org>
Message-ID: <alpine.DEB.2.00.1101121837580.8745@chino.kir.corp.google.com>
References: <1293731369-10851-1-git-send-email-tj@kernel.org> <1293731369-10851-7-git-send-email-tj@kernel.org>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 30 Dec 2010, Tejun Heo wrote:

> After the previous patch, apic->cpu_to_logical_apicid() is no longer
> used.  Kill it.
> 
> For apic types with custom cpu_to_logical_apicid() which is also used
> for other purposes, remove the function and modify its users to do the
> mapping directly.
> 
> #ifdef's on CONFIG_SMP in es7000_32 and summit_32 are ignored during
> conversion as they are not used for UP kernels.
> 
> Signed-off-by: Tejun Heo <tj@kernel.org>

Acked-by: David Rientjes <rientjes@google.com>
