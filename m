Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754097Ab1AFVil (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Jan 2011 16:38:41 -0500
Received: from mail.perches.com ([173.55.12.10]:3004 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753908Ab1AFVij (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Jan 2011 16:38:39 -0500
Subject: Re: [patch] checkpatch: putting the && or || on the wrong line
From: Joe Perches <joe@perches.com>
To: Krzysztof Halasa <khc@pm.waw.pl>
Cc: linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
In-Reply-To: <m37hehloon.fsf@intrepid.localdomain>
References: <20110104055900.GA5062@bicker>
	 <20110104163836.GA30317@fieldses.org>
	 <20110104164414.GX5875@const.bordeaux.inria.fr>
	 <1294160834.6617.51.camel@Joe-Laptop> <m3fwt7i740.fsf@intrepid.localdomain>
	 <1294249529.6617.118.camel@Joe-Laptop>
	 <m339p6p5zo.fsf@intrepid.localdomain>
	 <1294336674.12561.81.camel@Joe-Laptop>
	 <m3r5cplr2m.fsf@intrepid.localdomain>
	 <1294347753.12561.106.camel@Joe-Laptop>
	 <m37hehloon.fsf@intrepid.localdomain>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 06 Jan 2011 13:38:38 -0800
Message-ID: <1294349918.12561.142.camel@Joe-Laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2011-01-06 at 22:14 +0100, Krzysztof Halasa wrote:
> Joe Perches <joe@perches.com> writes:
> >> >> Sure, standardization is a good thing - to a certain point.
> >> >> We've passed this point long ago.
> > Right.  It's all exactly the same.
> > We agree.  Cites aren't necessary.
> People complained on lkml and other lists that the CodingStyle /
> checkpatch went way too far many times. So the evidence is there, in the
> list archives, and I guess even now you're getting feedback on this.

People complain, that's a fact.

> OTOH you failed to show evidence that super-strict standardization
> benefits anyone.

I don't need to.

If you don't agree with the assertion,
facts likely won't change your mind.
You'll more likely dispute the facts.

Look up this paper if you care to though:

Evaluating the Relation Between Coding
Standard Violations and Faults Within and
Across Software Versions

Cathal Boogerd and Leon Moonen

http://swerl.tudelft.nl/twiki/pub/Main/TechnicalReports/TUD-SERG-2009-008.pdf

RQ2 Are files or modules with a higher violation
density more fault-prone?

This holds for 10 rules in the standard, with some reserva-
tions. There is no reliable prediction for files without ac-
tive development (no changes) nor for files without viola-
tions. Also, the observed relation becomes less pronounced
in time, as the number of registered open faults decreases.


