Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756235Ab0GEJLc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Jul 2010 05:11:32 -0400
Received: from h5.dl5rb.org.uk ([81.2.74.5]:41067 "EHLO h5.dl5rb.org.uk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753374Ab0GEJLa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Jul 2010 05:11:30 -0400
Date: Mon, 5 Jul 2010 10:11:24 +0100
From: Ralf Baechle <ralf@linux-mips.org>
To: Shane McDonald <mcdonald.shane@gmail.com>
Cc: Christoph Egger <siccegge@cs.fau.de>, linux-mips@linux-mips.org,
       linux-kernel@vger.kernel.org, vamos@i4.informatik.uni-erlangen.de
Subject: Re: [PATCH 7/9] Removing dead CONFIG_PMCTWILED
Message-ID: <20100705091124.GB4461@linux-mips.org>
References: <cover.1275925108.git.siccegge@cs.fau.de>
 <0a4b5e5841e7842f7b80e368c1d103b5e98d3335.1275925108.git.siccegge@cs.fau.de>
 <AANLkTin3EsoPJPb9s7_nwSrWY9HihXMJHorAK96dKKIa@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AANLkTin3EsoPJPb9s7_nwSrWY9HihXMJHorAK96dKKIa@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 10, 2010 at 01:24:08PM -0600, Shane McDonald wrote:

> On Wed, Jun 9, 2010 at 5:22 AM, Christoph Egger <siccegge@cs.fau.de> wrote:
> > CONFIG_PMCTWILED doesn't exist in Kconfig, therefore removing all
> > references for it from the source code.
> >
> > Signed-off-by: Christoph Egger <siccegge@cs.fau.de>

Queued for 2.6.26.  Thanks,

  Ralf
