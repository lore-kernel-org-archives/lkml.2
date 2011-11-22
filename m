Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754660Ab1KVGLl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Nov 2011 01:11:41 -0500
Received: from mail-yw0-f46.google.com ([209.85.213.46]:41537 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752739Ab1KVGLk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Nov 2011 01:11:40 -0500
Date: Mon, 21 Nov 2011 22:11:37 -0800 (PST)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Eric Dumazet <eric.dumazet@gmail.com>
cc: Christoph Lameter <cl@linux-foundation.org>,
        Pekka Enberg <penberg@kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] slub: fix slub_max_order Documentation
In-Reply-To: <1321941549.27077.17.camel@edumazet-laptop>
Message-ID: <alpine.DEB.2.00.1111212211250.29325@chino.kir.corp.google.com>
References: <1321941549.27077.17.camel@edumazet-laptop>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 22 Nov 2011, Eric Dumazet wrote:

> slub_max_order default is 3 (aka PAGE_ALLOC_COSTLY_ORDER), not 1
> 
> Signed-off-by: Eric Dumazet <eric.dumazet@gmail.com>

Acked-by: David Rientjes <rientjes@google.com>
