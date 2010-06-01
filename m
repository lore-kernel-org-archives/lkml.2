Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756645Ab0FANrb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jun 2010 09:47:31 -0400
Received: from nlpi157.sbcis.sbc.com ([207.115.36.171]:50123 "EHLO
	nlpi157.prodigy.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756222Ab0FANra (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jun 2010 09:47:30 -0400
Date: Tue, 1 Jun 2010 08:44:11 -0500 (CDT)
From: Christoph Lameter <cl@linux-foundation.org>
X-X-Sender: cl@router.home
To: Pekka Enberg <penberg@cs.helsinki.fi>
cc: Heiko Carstens <heiko.carstens@de.ibm.com>, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org
Subject: Re: [BUG] slub crashes on dma allocations
In-Reply-To: <4C023854.3090002@cs.helsinki.fi>
Message-ID: <alpine.DEB.2.00.1006010844020.6979@router.home>
References: <20100526153757.GB2232@osiris.boeblingen.de.ibm.com> <alpine.DEB.2.00.1005270916220.5762@router.home> <20100527190440.GA2205@osiris.boeblingen.de.ibm.com> <4C023854.3090002@cs.helsinki.fi>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 30 May 2010, Pekka Enberg wrote:

> > Yes, that fixes the bug. Thanks!
>
> We need this for .33 and .34 stable, right?

Right.

