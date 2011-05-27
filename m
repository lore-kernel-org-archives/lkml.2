Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756893Ab1E0Tnz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 May 2011 15:43:55 -0400
Received: from smtp-out.google.com ([216.239.44.51]:22611 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756487Ab1E0Tnw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 May 2011 15:43:52 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id
         :references:user-agent:mime-version:content-type;
        b=QcEqHY4a8DVljfZarkid/+XCbP7e1XaDv2PREi4RlAUu8ki9DHNmNuJAPyJz+4g2I9
         Q0he24S89QN+a5qvYI8Q==
Date: Fri, 27 May 2011 12:43:47 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Christoph Lameter <cl@linux.com>
cc: Pekka Enberg <penberg@cs.helsinki.fi>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        "H. Peter Anvin" <hpa@zytor.com>, linux-kernel@vger.kernel.org,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [slubllv6 08/17] slub: Pass kmem_cache struct to lock and freeze
 slab
In-Reply-To: <20110526181506.008690257@linux.com>
Message-ID: <alpine.DEB.2.00.1105271243150.3972@chino.kir.corp.google.com>
References: <20110526181442.789868308@linux.com> <20110526181506.008690257@linux.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 26 May 2011, Christoph Lameter wrote:

> We need more information about the slab for the cmpxchg implementation.
> 
> Signed-off-by: Christoph Lameter <cl@linux.com>

Acked-by: David Rientjes <rientjes@google.com>
