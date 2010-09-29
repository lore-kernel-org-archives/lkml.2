Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755860Ab0I2UaS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Sep 2010 16:30:18 -0400
Received: from smtp-out.google.com ([216.239.44.51]:37793 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755754Ab0I2UaQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Sep 2010 16:30:16 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id:
	references:user-agent:mime-version:content-type:x-system-of-record;
	b=KDNrDKvNHfQhYJYiSPc7EG+uNCCc94JkZY+z1axcsR1PiAGEXMpOov+2Z62DiAF78
	keuuxdR+xo/DuJdGuv5zw==
Date: Wed, 29 Sep 2010 13:30:11 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Namhyung Kim <namhyung@gmail.com>
cc: Christoph Lameter <cl@linux-foundation.org>,
        Pekka Enberg <penberg@cs.helsinki.fi>, Matt Mackall <mpm@selenic.com>,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/3] slub: Fix signedness warnings
In-Reply-To: <1285761735-31499-1-git-send-email-namhyung@gmail.com>
Message-ID: <alpine.DEB.2.00.1009291329400.9797@chino.kir.corp.google.com>
References: <1285761735-31499-1-git-send-email-namhyung@gmail.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 29 Sep 2010, Namhyung Kim wrote:

> The bit-ops routines require its arg to be a pointer to unsigned long.
> This leads sparse to complain about different signedness as follows:
> 
>  mm/slub.c:2425:49: warning: incorrect type in argument 2 (different signedness)
>  mm/slub.c:2425:49:    expected unsigned long volatile *addr
>  mm/slub.c:2425:49:    got long *map
> 
> Signed-off-by: Namhyung Kim <namhyung@gmail.com>

Acked-by: David Rientjes <rientjes@google.com>
