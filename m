Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755396Ab2JPAxU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Oct 2012 20:53:20 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:64941 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751679Ab2JPAxS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Oct 2012 20:53:18 -0400
Date: Mon, 15 Oct 2012 17:53:16 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Christoph Lameter <cl@linux.com>
cc: Richard Kennedy <richard@rsk.demon.co.uk>,
        Pekka Enberg <penberg@kernel.org>, Matt Mackall <mpm@selenic.com>,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] SLUB: remove hard coded magic numbers from
 resiliency_test
In-Reply-To: <0000013a66294083-76b27acc-ede7-45d7-849a-0932adecac14-000000@email.amazonses.com>
Message-ID: <alpine.DEB.2.00.1210151753060.31712@chino.kir.corp.google.com>
References: <1350145885-6099-1-git-send-email-richard@rsk.demon.co.uk> <1350145885-6099-2-git-send-email-richard@rsk.demon.co.uk> <0000013a66294083-76b27acc-ede7-45d7-849a-0932adecac14-000000@email.amazonses.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 15 Oct 2012, Christoph Lameter wrote:

> > Use the always inlined function kmalloc_index to translate
> > sizes to indexes, so that we don't have to have the slab indexes
> > hard coded in two places.
> 
> Acked-by: Christoph Lameter <cl@linux.com>
> 

Shouldn't this be using get_slab() instead?
