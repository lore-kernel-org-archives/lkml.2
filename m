Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753632Ab0DTGnA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Apr 2010 02:43:00 -0400
Received: from waste.org ([173.11.57.241]:58353 "EHLO waste.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753561Ab0DTGm6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Apr 2010 02:42:58 -0400
Subject: Re: [Bug #15601] [BUG] SLOB breaks Crypto
From: Matt Mackall <mpm@selenic.com>
To: Pekka Enberg <penberg@cs.helsinki.fi>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Maciej Rutecki <maciej.rutecki@gmail.com>, michael-dev@fami-braun.de,
       Herbert Xu <herbert@gondor.hengli.com.au>
In-Reply-To: <z2h84144f021004192340z98fcc1c5m1544233f2ea6c0c4@mail.gmail.com>
References: <deuQKFRcc0B.A.3EG.BRSzLB@tosh> <YeFfFNFyTSF.A.mIB.aSSzLB@tosh>
	 <z2h84144f021004192340z98fcc1c5m1544233f2ea6c0c4@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 20 Apr 2010 01:42:54 -0500
Message-ID: <1271745774.4068.805.camel@calx>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2010-04-20 at 09:40 +0300, Pekka Enberg wrote:
> On Tue, Apr 20, 2010 at 6:19 AM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
> > This message has been generated automatically as a part of a summary report
> > of recent regressions.
> >
> > The following bug entry is on the current list of known regressions
> > from 2.6.33.  Please verify if it still should be listed and let the tracking team
> > know (either way).
> >
> >
> > Bug-Entry       : http://bugzilla.kernel.org/show_bug.cgi?id=15601
> > Subject         : [BUG] SLOB breaks Crypto
> > Submitter       : michael-dev@fami-braun.de
> > Date            : 2010-03-15 13:39 (36 days old)
> > Message-ID      : <4B9E38AF.70309@fami-braun.de>
> > References      : http://marc.info/?l=linux-kernel&m=126866044724539&w=2
> 
> Ping?

This was last in a need-more-info state, if I recall correctly. I
haven't reproduced it.

-- 
http://selenic.com : development and support for Mercurial and Linux


