Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753606Ab0K2MHJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Nov 2010 07:07:09 -0500
Received: from hofr.at ([212.69.189.236]:35279 "EHLO mail.hofr.at"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753520Ab0K2MHH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Nov 2010 07:07:07 -0500
X-Greylist: delayed 581 seconds by postgrey-1.27 at vger.kernel.org; Mon, 29 Nov 2010 07:07:07 EST
Date: Mon, 29 Nov 2010 12:57:24 +0100
From: Nicholas Mc Guire <der.herr@hofr.at>
To: Christian Borntraeger <borntraeger@de.ibm.com>
Cc: Segher Boessenkool <segher@kernel.crashing.org>,
        Am?rico Wang <xiyou.wangcong@gmail.com>, Hui Zhu <teawater@gmail.com>,
        linux-kernel@vger.kernel.org, gdb@sourceware.org,
        hellogcc@freelists.org, linux-kbuild@vger.kernel.org
Subject: Re: [PATCH] Built kernel without -O2 option
Message-ID: <20101129115724.GA32318@opentech.at>
References: <AANLkTimewZ4QhxzL2vOYYV85pegy8Fu6Rb4XUAPqGUXS@mail.gmail.com> <20101129081619.GD5218@cr0.nay.redhat.com> <4CF37603.5080301@de.ibm.com> <52488.94.211.195.167.1291029121.squirrel@gate.crashing.org> <4CF38BBA.4020202@de.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4CF38BBA.4020202@de.ibm.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 29 Nov 2010, Christian Borntraeger wrote:

> Am 29.11.2010 12:12, schrieb Segher Boessenkool:
> >> In essence -O2 just tells gcc to activate a list of optimizations
> >> gcc  -Q -O2 --help=optimizers

I think for completness you would need to pass

 gcc -Wextra -Q -O2 --help=optimizers

or you could miss some options

> >> tells you what.
> > 
> > Not quite; see http://gcc.gnu.org/wiki/FAQ#optimization-options .
> > 
> 
> Erm...right. Thank you.

well I guess you always could explicidly turn off all optioins with 
-fnoWHATEVER you want to disable and thus remove all unwanted flags 
- admitedly a bit painfull though.

hofrat
