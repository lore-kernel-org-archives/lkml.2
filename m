Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753997Ab2HaOz7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Aug 2012 10:55:59 -0400
Received: from cantor2.suse.de ([195.135.220.15]:46567 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753815Ab2HaOz6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Aug 2012 10:55:58 -0400
Date: Fri, 31 Aug 2012 16:55:56 +0200
From: Michal Marek <mmarek@suse.cz>
To: Julia Lawall <julia.lawall@lip6.fr>
Cc: Lars-Peter Clausen <lars@metafoo.de>, Julia Lawall <julia@diku.dk>,
        linux-kernel@vger.kernel.org, cocci@diku.dk
Subject: Re: [Cocci] [PATCH] scripts/coccinelle: ptr_ret: Add ternary
 operator version
Message-ID: <20120831145556.GD11531@sepie.suse.cz>
References: <1345538998-24600-1-git-send-email-lars@metafoo.de>
 <alpine.DEB.2.02.1208211105300.1984@hadrien>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.02.1208211105300.1984@hadrien>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 21, 2012 at 11:06:35AM +0200, Julia Lawall wrote:
> 
> 
> On Tue, 21 Aug 2012, Lars-Peter Clausen wrote:
> 
> > Add a ternary operator version of the open-coded PTR_RET().
> >
> > Signed-off-by: Lars-Peter Clausen <lars@metafoo.de>
> 
> Signed-off-by: Julia Lawall <Julia.Lawall@lip6.fr>

Applied to kbuild.git#misc, thanks.

Michal
