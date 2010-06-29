Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756401Ab0F2QXs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jun 2010 12:23:48 -0400
Received: from nlpi157.sbcis.sbc.com ([207.115.36.171]:38483 "EHLO
	nlpi157.prodigy.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755974Ab0F2QXr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jun 2010 12:23:47 -0400
Date: Tue, 29 Jun 2010 10:42:42 -0500 (CDT)
From: Christoph Lameter <cl@linux-foundation.org>
X-X-Sender: cl@router.home
To: Pekka Enberg <penberg@cs.helsinki.fi>
cc: linux-mm@kvack.org, Manfred Spraul <manfred@colorfullife.com>,
       Nick Piggin <npiggin@suse.de>, Matt Mackall <mpm@selenic.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [S+Q 01/16] [PATCH] ipc/sem.c: Bugfix for semop() not reporting
  successful operation
In-Reply-To: <AANLkTinmvRtH24uflD9e7MknaW6tgMSnN75vVgaj0IM6@mail.gmail.com>
Message-ID: <alpine.DEB.2.00.1006291042100.16135@router.home>
References: <20100625212026.810557229@quilx.com> <20100625212101.622422748@quilx.com> <AANLkTinmvRtH24uflD9e7MknaW6tgMSnN75vVgaj0IM6@mail.gmail.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a patch from Manfred. Required to make 2.6.35-rc3 work.


