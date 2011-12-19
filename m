Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753157Ab1LSPeX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Dec 2011 10:34:23 -0500
Received: from mga01.intel.com ([192.55.52.88]:23113 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752145Ab1LSPeU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Dec 2011 10:34:20 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="97937146"
Date: Mon, 19 Dec 2011 16:38:53 +0100
From: Samuel Ortiz <sameo@linux.intel.com>
To: NeilBrown <neilb@suse.de>
Cc: Igor Grinberg <grinberg@compulab.co.il>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] MFD: TWL: add power off functionality
Message-ID: <20111219153853.GN11800@sortiz-mobl>
References: <1321177790-5886-1-git-send-email-grinberg@compulab.co.il>
 <4ED205F9.3070908@compulab.co.il>
 <4EE71FCA.8040000@compulab.co.il>
 <20111219113645.GI11800@sortiz-mobl>
 <20111219224519.05c81112@notabene.brown>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111219224519.05c81112@notabene.brown>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Neil, Igor,

On Mon, Dec 19, 2011 at 10:45:19PM +1100, NeilBrown wrote:
> On Mon, 19 Dec 2011 12:36:45 +0100 Samuel Ortiz <sameo@linux.intel.com> wrote:
> 
> > Hi Igor,
> > 
> > On Tue, Dec 13, 2011 at 11:50:02AM +0200, Igor Grinberg wrote:
> > > Samuel,
> > > 
> > > Can we get this one into 3.3?
> > Afaiu, af8db1508f2c9f3b6e633e2d2d906c6557c617f9 needs to be (partially)
> > reverted for it to be working. Is the core PM fix queued for 3.3 as well ? 
> > 
> > Cheers,
> > Samuel.
> > 
> 
> 
> Already fixed by
> 
> commit fe6b91f47080eb17d21cbf2a39311877d57f6938
Good, I applied Igor's patch then.

Cheers,
Samuel.

-- 
Intel Open Source Technology Centre
http://oss.intel.com/
