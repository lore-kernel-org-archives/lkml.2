Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753984Ab2KMAui (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Nov 2012 19:50:38 -0500
Received: from zene.cmpxchg.org ([85.214.230.12]:34127 "EHLO zene.cmpxchg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753727Ab2KMAuS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Nov 2012 19:50:18 -0500
Date: Mon, 12 Nov 2012 19:50:14 -0500
From: Johannes Weiner <hannes@cmpxchg.org>
To: Joonsoo Kim <js1304@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, Haavard Skinnemoen <hskinnemoen@gmail.com>,
        Hans-Christian Egtvedt <egtvedt@samfundet.no>
Subject: Re: [PATCH 2/4] avr32, kconfig: remove HAVE_ARCH_BOOTMEM
Message-ID: <20121113005013.GB10092@cmpxchg.org>
References: <1352737915-30906-1-git-send-email-js1304@gmail.com>
 <1352737915-30906-2-git-send-email-js1304@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1352737915-30906-2-git-send-email-js1304@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 13, 2012 at 01:31:53AM +0900, Joonsoo Kim wrote:
> Now, there is no code for CONFIG_HAVE_ARCH_BOOTMEM.
> So remove it.
> 
> Cc: Haavard Skinnemoen <hskinnemoen@gmail.com>
> Cc: Hans-Christian Egtvedt <egtvedt@samfundet.no>
> Signed-off-by: Joonsoo Kim <js1304@gmail.com>

Acked-by: Johannes Weiner <hannes@cmpxchg.org>
