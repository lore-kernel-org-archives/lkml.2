Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934794Ab1JaWyo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Oct 2011 18:54:44 -0400
Received: from smtp-out.google.com ([216.239.44.51]:45248 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934773Ab1JaWyk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Oct 2011 18:54:40 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=dkim-signature:date:from:x-x-sender:to:cc:subject:
	in-reply-to:message-id:references:user-agent:mime-version:content-type:x-system-of-record;
	b=wEqQ5oq+WwsECgjI/O5eATTzv/LnDExN5vkaWMEII1tEw9ukEZ9IKrBw9dCtYMJz1
	tT59Y+g2wG55+Sl7y+BxQ==
Date: Mon, 31 Oct 2011 15:54:34 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Pekka Enberg <penberg@kernel.org>
cc: x86@kernel.org, linux-kernel@vger.kernel.org, Tejun Heo <tj@kernel.org>,
        Yinghai Lu <yinghai@kernel.org>,
        "H. Peter Anvin" <hpa@linux.intel.com>
Subject: Re: [RFC/PATCH 5/7] x86, mm: Use max_low_pfn for ZONE_NORMAL on
 64-bit
In-Reply-To: <1319811801-1725-5-git-send-email-penberg@kernel.org>
Message-ID: <alpine.DEB.2.00.1110311554230.22237@chino.kir.corp.google.com>
References: <1319811801-1725-1-git-send-email-penberg@kernel.org> <1319811801-1725-5-git-send-email-penberg@kernel.org>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 28 Oct 2011, Pekka Enberg wrote:

> 64-bit has no highmem so max_low_pfn is always the same as 'max_pfn'.
> 
> Cc: Tejun Heo <tj@kernel.org>
> Cc: Yinghai Lu <yinghai@kernel.org>
> Cc: H. Peter Anvin <hpa@linux.intel.com>
> Cc: David Rientjes <rientjes@google.com>
> Signed-off-by: Pekka Enberg <penberg@kernel.org>

Acked-by: David Rientjes <rientjes@google.com>
