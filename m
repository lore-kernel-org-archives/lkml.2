Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753912Ab1HZPRZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Aug 2011 11:17:25 -0400
Received: from mail-pz0-f42.google.com ([209.85.210.42]:43322 "EHLO
	mail-pz0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753439Ab1HZPRY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Aug 2011 11:17:24 -0400
Subject: Re: [PATCH] slab: avoid unnecessary touching of a partial slab
From: Zhao Jin <cronozhj@gmail.com>
To: Christoph Lameter <cl@linux.com>
Cc: penberg@kernel.org, mpm@selenic.com, trivial@kernel.org,
        linux-kernel@vger.kernel.org
In-Reply-To: <alpine.DEB.2.00.1108261004430.5818@router.home>
References: <CADqbE97Vj0UV-2XvpkoELwdey_Xw7iCsF1AhQNFjwxY583SUwg@mail.gmail.com>
	 <alpine.DEB.2.00.1108260841570.5818@router.home>
	 <1314370016.8991.38.camel@vm>
	 <alpine.DEB.2.00.1108260950220.5818@router.home>
	 <1314370954.8991.46.camel@vm>
	 <alpine.DEB.2.00.1108261004430.5818@router.home>
Content-Type: text/plain; charset="us-ascii"
Date: Fri, 26 Aug 2011 23:09:34 +0800
Message-ID: <1314371374.8991.49.camel@vm>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2011-08-26 at 10:05 -0500, Christoph Lameter wrote:
> On Fri, 26 Aug 2011, Zhao Jin wrote:
> 
> > > Correct but still tthe del/add is a list_move operation. Convert that the
> > > other case as well?
> > >
> > Yes. The patch avoids list_del/list_add only if it is the case that a
> > partial slab was used for refilling and remains partial (that is:
> > partial => partial). If it is not the case( so it must be either partial
> > => full, free => full or free => partial) the patched code behaves the
> > same as current (list_del/list_add).
> 
> The second case is what I want you to change to list_move.
> 
> 
Oops. I misunderstood your reply... I shall do it. Thanks a lot for
pointing it out.

Regards,
zhj


