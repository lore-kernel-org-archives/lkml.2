Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755864Ab0ERAlV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 May 2010 20:41:21 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:59720 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752542Ab0ERAlT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 May 2010 20:41:19 -0400
Date: Tue, 18 May 2010 02:40:48 +0200
From: Ingo Molnar <mingo@elte.hu>
To: =?iso-8859-1?Q?J=F6rn?= Engel <joern@logfs.org>
Cc: Randy Dunlap <randy.dunlap@oracle.com>,
       Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
       LKML <linux-kernel@vger.kernel.org>, logfs@logfs.org
Subject: Re: linux-next -> 2.6.34: Tree for April 28 (logfs)
Message-ID: <20100518004048.GF20590@elte.hu>
References: <20100428164341.cee2911a.sfr@canb.auug.org.au>
 <20100428085604.0566092a.randy.dunlap@oracle.com>
 <20100505092020.66a461fa.randy.dunlap@oracle.com>
 <20100505203548.GI25129@logfs.org>
 <20100509062010.GA9485@elte.hu>
 <20100516204826.2625eed2.randy.dunlap@oracle.com>
 <20100517193159.GE28003@logfs.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20100517193159.GE28003@logfs.org>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Jörn Engel <joern@logfs.org> wrote:

> On Sun, 16 May 2010 20:48:26 -0700, Randy Dunlap wrote:
> > 
> > This fix is now needed in 2.6.34....
> 
> I didn't send Linus a pull request, as I was on 
> vacation last week.  Bad timing, given the 2.6.34 
> release date. :(

Dont worry about it too much - the likehood of the 
build failure was very low, around 1:50 in my 
randconfig tests. I doubt any real user ran into this 
spontaenously - and randconfig folks know how to fix 
rare build failures :-)

You might still want to forward the commit to 
-stable, once it's in Linus's tree.

Thanks,

	Ingo
