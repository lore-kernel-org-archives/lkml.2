Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754478Ab1CUUPy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Mar 2011 16:15:54 -0400
Received: from smtp-out.google.com ([74.125.121.67]:19948 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753775Ab1CUUPw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Mar 2011 16:15:52 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id
         :references:user-agent:mime-version:content-type;
        b=C2ufMeAgOSsalNHaygjyBzyfDQWqHytSzEGY5AtEyINsPTk+tdfWsyjRe4L4+zw0lT
         zYQFEgYwzNkMfdKGjP6w==
Date: Mon, 21 Mar 2011 13:15:44 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Prasad Joshi <prasadjoshi124@gmail.com>
cc: tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com, x86@kernel.org,
        linux-kernel@vger.kernel.org, mitra@kqinfotech.com
Subject: Re: [RFC][PATCH v3 03/22] mm, x86: add gfp flags variant of pud,
 pmd, and pte allocations
In-Reply-To: <20110321190520.GB6541@prasad-kvm>
Message-ID: <alpine.DEB.2.00.1103211315300.5792@chino.kir.corp.google.com>
References: <20110318194135.GA4746@prasad-kvm> <20110318194341.GB4746@prasad-kvm> <20110318194600.GC4746@prasad-kvm> <20110318194740.GD4746@prasad-kvm> <alpine.DEB.2.00.1103181514340.30968@chino.kir.corp.google.com> <20110321190520.GB6541@prasad-kvm>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 21 Mar 2011, Prasad Joshi wrote:

> Thanks a lot David for your reply. Sending a new patch with the changes suggested by you.
> 
> - Added __pud_alloc_one() function which is similar to pud_alloc_one(), but
>   accepts an additional argument of type gfp_t. The function pud_alloc_one()
>   calls __pud_alloc_one().
> 
> - similar changes for pmd allocations. The newly added function name is__pmd_alloc_one.
> 
> - Similar changes for pte allocation. Added function __pte_alloc_one_kernel.
> 
> - changes help in fixing the Bug 30702
> 
> Signed-off-by: Prasad Joshi <prasadjoshi124@gmail.com>
> Signed-off-by: Anand Mitra <mitra@kqinfotech.com>

Acked-by: David Rientjes <rientjes@google.com>
