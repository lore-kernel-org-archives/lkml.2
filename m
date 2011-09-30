Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757363Ab1I3H5S (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Sep 2011 03:57:18 -0400
Received: from mtagate1.uk.ibm.com ([194.196.100.161]:48773 "EHLO
	mtagate1.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755538Ab1I3H5R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Sep 2011 03:57:17 -0400
Date: Fri, 30 Sep 2011 09:57:12 +0200
From: Heiko Carstens <heiko.carstens@de.ibm.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Martin Schwidefsky <schwidefsky@de.ibm.com>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: Re: linux-next: build failure after merge of the final tree
Message-ID: <20110930075712.GA2412@osiris.boeblingen.de.ibm.com>
References: <20110930110514.eadb199f27c5418b28cab6c9@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110930110514.eadb199f27c5418b28cab6c9@canb.auug.org.au>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 30, 2011 at 11:05:14AM +1000, Stephen Rothwell wrote:
> Hi all,
> 
> After merging the final tree, the next-20110929 build (s390x allmodconfig)
> failed like this:
> 
> drivers/s390/char/zcore.c:393: error: 'THIS_MODULE' undeclared here (not in a function)
> drivers/s390/char/zcore.c:741: error: expected declaration specifiers or '...' before string constant
> drivers/s390/char/zcore.c:741: warning: data definition has no type or storage class
> drivers/s390/char/zcore.c:741: warning: type defaults to 'int' in declaration of 'MODULE_AUTHOR'
> drivers/s390/char/zcore.c:741: warning: function declaration isn't a prototype
> drivers/s390/char/zcore.c:742: error: expected declaration specifiers or '...' before string constant
> drivers/s390/char/zcore.c:742: warning: data definition has no type or storage class
> drivers/s390/char/zcore.c:742: warning: type defaults to 'int' in declaration of 'MODULE_DESCRIPTION'
> drivers/s390/char/zcore.c:742: warning: function declaration isn't a prototype
> drivers/s390/char/zcore.c:743: error: expected declaration specifiers or '...' before string constant
> drivers/s390/char/zcore.c:743: warning: data definition has no type or storage class
> drivers/s390/char/zcore.c:743: warning: type defaults to 'int' in declaration of 'MODULE_LICENSE'
> drivers/s390/char/zcore.c:743: warning: function declaration isn't a prototype
> 
> Probably revealed by the module.h split up.
> 
> This file needs to include module.h

Hmm.. wondering why I haven't seen that during my build tests a couple of
days ago. Anyway, thanks for letting us know!
I added a patch to our local tree. As soon as Martin pushes it out it
should be fixed.

Thanks,
Heiko
