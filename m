Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753867Ab1BOAAc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Feb 2011 19:00:32 -0500
Received: from ozlabs.org ([203.10.76.45]:44166 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751997Ab1BOAA3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Feb 2011 19:00:29 -0500
From: Rusty Russell <rusty@rustcorp.com.au>
To: sedat.dilek@gmail.com
Subject: Re: [next-20110214] Kernel-modules with unknown parameter
Date: Tue, 15 Feb 2011 10:30:26 +1030
User-Agent: KMail/1.13.5 (Linux/2.6.35-25-generic; KDE/4.5.1; i686; ; )
Cc: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        Randy Dunlap <randy.dunlap@oracle.com>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>
References: <AANLkTimM1Tmws46DUyoNGsn+P8WN1XPsRu=L8yPzd=xU@mail.gmail.com> <AANLkTikO=5zBCvPbd2MXqgzE_mvnabTtH_e2C5_5bpQv@mail.gmail.com> <AANLkTinFOPc+BM8cnPE3SLt7Dc2TFOw1v+bntFu01hpO@mail.gmail.com>
In-Reply-To: <AANLkTinFOPc+BM8cnPE3SLt7Dc2TFOw1v+bntFu01hpO@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201102151030.26956.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 14 Feb 2011 11:45:59 pm Sedat Dilek wrote:
> >> Any idea what's going on? Stephen, Randy noticed the same like me?

Dmitry broke module parameters with a "trivial" transform which turned out
not to be.

I wasn't paying enough attention, and let it through.

> My damn brain can't understand - looking at the series file in [2] -
> why the hell the "possible" patch [3] is not included in linux-next?

There are markers in the series file, which indicate what goes into
linux-next.

Cheers,
Rusty.
