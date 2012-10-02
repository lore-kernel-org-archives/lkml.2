Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754681Ab2JBWtd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Oct 2012 18:49:33 -0400
Received: from mx1.redhat.com ([209.132.183.28]:45243 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753901Ab2JBWt3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Oct 2012 18:49:29 -0400
Date: Wed, 3 Oct 2012 00:49:21 +0200
From: Andrea Arcangeli <aarcange@redhat.com>
To: David Miller <davem@davemloft.net>
Cc: linux-mm@kvack.org, sparclinux@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
        akpm@linux-foundation.org, hannes@cmpxchg.org
Subject: Re: [PATCH 6/8] mm: Make transparent huge code not depend upon the
 details of pgtable_t
Message-ID: <20121002224921.GR4763@redhat.com>
References: <20121002.182718.250164928532772411.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121002.182718.250164928532772411.davem@davemloft.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Dave,

On Tue, Oct 02, 2012 at 06:27:18PM -0400, David Miller wrote:
> 
> The code currently assumes that pgtable_t is a struct page pointer.
> 
> Fix this by pushing pgtable management behind arch helper functions.

This should be fixed in -mm already, it's from the s390x support.
