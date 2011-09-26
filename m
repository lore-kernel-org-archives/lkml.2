Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751432Ab1IZH35 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Sep 2011 03:29:57 -0400
Received: from casper.infradead.org ([85.118.1.10]:33892 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750808Ab1IZH34 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Sep 2011 03:29:56 -0400
Subject: Re: [PATCH 4/5] mm: Only IPI CPUs to drain local pages if they exist
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Gilad Ben-Yossef <gilad@benyossef.com>
Cc: linux-kernel@vger.kernel.org, Frederic Weisbecker <fweisbec@gmail.com>,
        Russell King <linux@arm.linux.org.uk>,
        Chris Metcalf <cmetcalf@tilera.com>, linux-mm@kvack.org,
        Christoph Lameter <cl@linux-foundation.org>,
        Pekka Enberg <penberg@kernel.org>, Matt Mackall <mpm@selenic.com>
Date: Mon, 26 Sep 2011 09:29:25 +0200
In-Reply-To: <1316940890-24138-5-git-send-email-gilad@benyossef.com>
References: <1316940890-24138-1-git-send-email-gilad@benyossef.com>
	 <1316940890-24138-5-git-send-email-gilad@benyossef.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Mailer: Evolution 3.0.3- 
Message-ID: <1317022165.9084.54.camel@twins>
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2011-09-25 at 11:54 +0300, Gilad Ben-Yossef wrote:
> +/* NOTE: If you call this function it is very likely you want to clear
> +   cpus_with_pcp as well. */
>  static void setup_pageset(struct per_cpu_pageset *p, unsigned long batch)
>  { 

  /*
   * Multi-line comment
   * style is like
   * this.
   */


