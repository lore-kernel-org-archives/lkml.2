Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751755Ab0CZQdd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Mar 2010 12:33:33 -0400
Received: from mail.perches.com ([173.55.12.10]:1118 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751217Ab0CZQdb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Mar 2010 12:33:31 -0400
Subject: Re: [Patch] fix packet loss and massive ping spikes with PPP
 multi-link
From: Joe Perches <joe@perches.com>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Richard Hartmann <richih.mailinglist@gmail.com>,
       linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
       linux-ppp@vger.kernel.org
In-Reply-To: <20100326160226.0159ac3b@lxorguk.ukuu.org.uk>
References: <2d460de71003260850x7f90d04cy79ac853464108182@mail.gmail.com>
	 <20100326160226.0159ac3b@lxorguk.ukuu.org.uk>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 26 Mar 2010 09:33:29 -0700
Message-ID: <1269621210.1541.102.camel@Joe-Laptop.home>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2010-03-26 at 16:02 +0000, Alan Cox wrote:
> > We are fully aware that this code is not nearly up for inclusion into
> > the kernel. What we hope to achieve is that someone with the skills to
> > do this properly will introduce an option to turn off fragmentation on
> > PPP multi-link or to just do away with it completely.
> 
> You should be able to manage that I'm sure:
[]
> MODULE_PARM_DESC(ml_expode, "Set this to zero to disabling multilink \
> 	fragmentation when talking to cisco devices");

trivial:

It's better to use something like:

MODULE_PARM_DESC(ml_expode, "Set this to zero to disable multilink "
			    "fragmentation when talking to cisco devices");

so odd spacing from the continuation line aren't
used in the description.

