Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754869Ab1BTEED (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Feb 2011 23:04:03 -0500
Received: from smtp-out.google.com ([74.125.121.67]:48966 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753576Ab1BTEDx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Feb 2011 23:03:53 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id
         :references:user-agent:mime-version:content-type;
        b=iMBiru1IUENPwek2iP6LUEk7mONoe5+Bd4vGcG05p3Sy/7mTw8ZwEveIikvOnEk5hm
         Y2FnJVQF3vxrjwIC/HFQ==
Date: Sat, 19 Feb 2011 20:03:48 -0800 (PST)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Yinghai Lu <yinghai@kernel.org>
cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>, Tejun Heo <tj@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Cyrill Gorcunov <gorcunov@gmail.com>
Subject: Re: [PATCH 3/4] x86, numa: cleanup x86_acpi_numa_init()
In-Reply-To: <4D5EC18F.2070103@kernel.org>
Message-ID: <alpine.DEB.2.00.1102191958200.32280@chino.kir.corp.google.com>
References: <4D5EC05A.60103@kernel.org> <4D5EC18F.2070103@kernel.org>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 18 Feb 2011, Yinghai Lu wrote:

> 
> make it more readable. put valid checking together.
> 
> Also restore old acpi_numa_init(). we don't need to touch it
> because already have x86 own wrapper.
> 
> We can limit change to x86 code only.
> 
> Signed-off-by: Yinghai Lu <yinghai@kernel.org>

Acked-by: David Rientjes <rientjes@google.com>
