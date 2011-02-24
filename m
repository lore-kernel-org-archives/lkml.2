Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756565Ab1BXV0n (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Feb 2011 16:26:43 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:52853 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756398Ab1BXV0k (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Feb 2011 16:26:40 -0500
Subject: Re: PowerPC BUG: using smp_processor_id() in preemptible code
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Hugh Dickins <hughd@google.com>, Jeremy Fitzhardinge <jeremy@goop.org>,
        linux-kernel@vger.kernel.org, linuxppc-dev@lists.ozlabs.org
In-Reply-To: <1298582606.8833.509.camel@pasglop>
References: <alpine.LSU.2.00.1012291413360.22939@sister.anvils>
	 <1293705910.17779.60.camel@pasglop>
	 <alpine.LSU.2.00.1102241216420.1708@sister.anvils>
	 <1298581675.5226.840.camel@laptop>  <1298582606.8833.509.camel@pasglop>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 24 Feb 2011 22:27:55 +0100
Message-ID: <1298582875.5226.844.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2011-02-25 at 08:23 +1100, Benjamin Herrenschmidt wrote:
> 
> I don't think that's needed here as there shall be no batching happening
> on the vmalloc space, but it can't hurt to merge it regardless :-)

Ah, due to the !batch->active thing? OK, then yeah Hugh's bit is
sufficient.

