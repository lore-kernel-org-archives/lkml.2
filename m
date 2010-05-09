Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751136Ab0EIGUW (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 May 2010 02:20:22 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:51034 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750944Ab0EIGUU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 May 2010 02:20:20 -0400
Date: Sun, 9 May 2010 08:20:10 +0200
From: Ingo Molnar <mingo@elte.hu>
To: J??rn Engel <joern@logfs.org>
Cc: Randy Dunlap <randy.dunlap@oracle.com>,
       Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
       LKML <linux-kernel@vger.kernel.org>, logfs@logfs.org
Subject: Re: linux-next: Tree for April 28 (logfs)
Message-ID: <20100509062010.GA9485@elte.hu>
References: <20100428164341.cee2911a.sfr@canb.auug.org.au>
 <20100428085604.0566092a.randy.dunlap@oracle.com>
 <20100505092020.66a461fa.randy.dunlap@oracle.com>
 <20100505203548.GI25129@logfs.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100505203548.GI25129@logfs.org>
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


* J??rn Engel <joern@logfs.org> wrote:

> On Wed, 5 May 2010 09:20:20 -0700, Randy Dunlap wrote:
> > On Wed, 28 Apr 2010 08:56:04 -0700 Randy Dunlap wrote:
> > 
> > > When CONFIG_BLOCK is not enabled:
> > > 
> > > fs/logfs/super.c:142: error: implicit declaration of function 'bdev_get_queue'
> > > fs/logfs/super.c:142: error: invalid type argument of '->' (have 'int')
> > 
> > Still have this build error in linux-next-May 5-2010.
> 
> Should be fixed now.  Sorry about the delay.

Please post the fix itself as well, i've ran into this and so did others.

Thanks,

	Ingo
