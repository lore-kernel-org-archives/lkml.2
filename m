Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754598Ab0JNEqK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Oct 2010 00:46:10 -0400
Received: from smtp-out.google.com ([216.239.44.51]:14731 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754528Ab0JNEqI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Oct 2010 00:46:08 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id
         :references:user-agent:mime-version:content-type;
        b=EtWPcQoOivrNdf+6am31oc52QRQkqzSuQufIQB+ueL8ifG7fYbrXLScRe2eligO0P0
         lqTuMiOxj2riLXU/0KzQ==
Date: Wed, 13 Oct 2010 21:46:02 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: "H. Peter Anvin" <hpa@zytor.com>
cc: Ingo Molnar <mingo@redhat.com>, Thomas Gleixner <tglx@linutronix.de>,
        Casey Dahlin <cdahlin@redhat.com>, x86@kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [patch] x86: allow ZONE_DMA to be configurable
In-Reply-To: <4CB688F4.9040706@zytor.com>
Message-ID: <alpine.DEB.2.00.1010132140550.20995@chino.kir.corp.google.com>
References: <alpine.DEB.2.00.1010131713160.24646@chino.kir.corp.google.com> <4CB64D8F.9080800@zytor.com> <alpine.DEB.2.00.1010131739010.27124@chino.kir.corp.google.com> <4CB65262.3070507@zytor.com> <alpine.DEB.2.00.1010131744540.27124@chino.kir.corp.google.com>
 <cbd8b37e-a1a3-4275-8acb-a76476211366@email.android.com> <alpine.DEB.2.00.1010131832400.794@chino.kir.corp.google.com> <4CB688F4.9040706@zytor.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 13 Oct 2010, H. Peter Anvin wrote:

> I guess that qualifies (barely, arguably, but let's not go there) as
> something that would be able to be carried under CONFIG_EMBEDDED
> (certainly not without).
> 

I'm not running a CONFIG_EMBEDDED kernel and I'm pretty sure Casey isn't 
either, so we'd still need to carry our own patches to change the Kconfig 
bool line anyway.

I'm suprised that we can't allow users who definitively know that they 
have no hardware limitations the ability to disable ZONE_DMA.  Would a 
strong caution in the Kconfig "help" text suffice or will you not be 
convinced?
