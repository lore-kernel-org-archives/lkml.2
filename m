Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758617Ab1EZWN7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 May 2011 18:13:59 -0400
Received: from smtp-out.google.com ([74.125.121.67]:61476 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756862Ab1EZWN5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 May 2011 18:13:57 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id
         :references:user-agent:mime-version:content-type;
        b=rfyTsURuChGVbd5ZOZrqwnfDOTTqxAQYV8u2gjWi2MKE3q0LeXgdK8G+3S5vHTFpdb
         +c2uKwMELfEDW6VH5oGw==
Date: Thu, 26 May 2011 15:13:52 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Christoph Lameter <cl@linux.com>
cc: Pekka Enberg <penberg@cs.helsinki.fi>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        "H. Peter Anvin" <hpa@zytor.com>, linux-kernel@vger.kernel.org,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [slubllv6 03/17] slub: Move page->frozen handling near where
 the page->freelist handling occurs
In-Reply-To: <20110526181503.129943104@linux.com>
Message-ID: <alpine.DEB.2.00.1105261441460.10790@chino.kir.corp.google.com>
References: <20110526181442.789868308@linux.com> <20110526181503.129943104@linux.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 26 May 2011, Christoph Lameter wrote:

> This is necessary because the frozen bit has to be handled in the same cmpxchg_double
> with the freelist and the counters.
> 
> Signed-off-by: Christoph Lameter <cl@linux.com>

Acked-by: David Rientjes <rientjes@google.com>
