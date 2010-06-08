Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752963Ab0FHPVL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jun 2010 11:21:11 -0400
Received: from mail.perches.com ([173.55.12.10]:2775 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751894Ab0FHPVJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jun 2010 11:21:09 -0400
Subject: Re: [PATCH 01/12] arch/cris: Remove unnecessary kmalloc casts
From: Joe Perches <joe@perches.com>
To: David Rientjes <rientjes@google.com>
Cc: Jiri Kosina <trivial@kernel.org>, linux-kernel@vger.kernel.org
In-Reply-To: <alpine.DEB.2.00.1006072143560.28717@chino.kir.corp.google.com>
References: <cover.1275968594.git.joe@perches.com>
	 <d3966486cc145e7eebdb8ee11d10ed928e2203b1.1275968594.git.joe@perches.com>
	 <alpine.DEB.2.00.1006072143560.28717@chino.kir.corp.google.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 08 Jun 2010 08:21:06 -0700
Message-ID: <1276010466.1571.508.camel@Joe-Laptop.home>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2010-06-07 at 21:44 -0700, David Rientjes wrote:
> On Mon, 7 Jun 2010, Joe Perches wrote:
> > And separate declaration from allocation
> > Still no error checking on failure, but it probably doesn't matter.
[]
> Why not fix the checkpatch failures at the same time?

I think that's better done in a separate pass.


