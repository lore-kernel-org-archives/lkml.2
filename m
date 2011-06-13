Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754196Ab1FMT3Y (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jun 2011 15:29:24 -0400
Received: from smtp101.prem.mail.ac4.yahoo.com ([76.13.13.40]:31674 "HELO
	smtp101.prem.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751569Ab1FMT3X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jun 2011 15:29:23 -0400
X-Yahoo-SMTP: _Dag8S.swBC1p4FJKLCXbs8NQzyse1SYSgnAbY0-
X-YMail-OSG: EYAjufcVM1mKny6q_H6oBJNL165IyK7.pE86y7TEC1gYepj
 S2ceTl7A4D7VqNsHJ3qJSE_U4mTB2BsqLDoBJX.KgdfNebA6BsorW0nfHYfl
 0GZ9dabsXKTwBArptu6svI.BLo1WVTyk9S2z_KlDzdrtKZjHTnya4ILdb47w
 w.SjFm1eCmjP.sTiHgyfC968q9nLwih3t1B.4oG6tDiUe5zH7b2mCCKidm08
 etoeo903UTXkmD3J7t2aQvFOmM7jd.qwl2tlKPu7OcxW.xOtkzfutzj.vjmJ
 FxiN93g0Y_ySy5noL0H7zRVv0QjcCR4.RXw7n3EY8gJOjt1AHmsi08dTqQ9S
 m2J0vD2hfTMgnHeVRAsPs3CJSnqRKhMWdjV0KxJHtzNmjM.og9P3oEWBEo36
 w056sE5WKEMB3rmphFfMVcCzHh5Ue_DGShLp8gPtEQoEqsDH4DWx9VHUtURm
 LGnCkU7aykSqGhMgC0SqyNogCZ9W6KbOoJozL6b0vmZRvg6LDBRB5uLw-
X-Yahoo-Newman-Property: ymail-3
Date: Mon, 13 Jun 2011 14:29:20 -0500 (CDT)
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@router.home
To: Pekka Enberg <penberg@kernel.org>
cc: Hugh Dickins <hughd@google.com>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, linuxppc-dev@lists.ozlabs.org
Subject: Re: [PATCH] slub: fix kernel BUG at mm/slub.c:1950!
In-Reply-To: <1307990048.11288.3.camel@jaguar>
Message-ID: <alpine.DEB.2.00.1106131428560.5601@router.home>
References: <alpine.LSU.2.00.1106121842250.31463@sister.anvils>  <alpine.DEB.2.00.1106131258300.3108@router.home> <1307990048.11288.3.camel@jaguar>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 13 Jun 2011, Pekka Enberg wrote:

> > Hmmm.. The allocpercpu in alloc_kmem_cache_cpus should take care of the
> > alignment. Uhh.. I see that a patch that removes the #ifdef CMPXCHG_LOCAL
> > was not applied? Pekka?
>
> This patch?
>
> http://git.kernel.org/?p=linux/kernel/git/penberg/slab-2.6.git;a=commitdiff;h=d4d84fef6d0366b585b7de13527a0faeca84d9ce
>
> It's queued and will be sent to Linus soon.

Ok it will also fix Hugh's problem then.

