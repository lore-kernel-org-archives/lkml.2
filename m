Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758544Ab1FAAgk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 May 2011 20:36:40 -0400
Received: from 173-166-109-252-newengland.hfc.comcastbusiness.net ([173.166.109.252]:36095
	"EHLO bombadil.infradead.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758394Ab1FAAgj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 May 2011 20:36:39 -0400
Date: Tue, 31 May 2011 20:36:34 -0400
From: Christoph Hellwig <hch@infradead.org>
To: Hugh Dickins <hughd@google.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org
Subject: Re: [PATCH 2/14] mm: move vmtruncate_range to truncate.c
Message-ID: <20110601003634.GA4433@infradead.org>
References: <alpine.LSU.2.00.1105301726180.5482@sister.anvils>
 <alpine.LSU.2.00.1105301735520.5482@sister.anvils>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LSU.2.00.1105301735520.5482@sister.anvils>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 30, 2011 at 05:36:57PM -0700, Hugh Dickins wrote:
> You would expect to find vmtruncate_range() next to vmtruncate()
> in mm/truncate.c: move it there.

Sounds fine to me.

