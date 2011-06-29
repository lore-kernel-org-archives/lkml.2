Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753987Ab1F2Igh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Jun 2011 04:36:37 -0400
Received: from mail.mnsspb.ru ([84.204.75.2]:58213 "EHLO mail.mnsspb.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753762Ab1F2Iga (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Jun 2011 04:36:30 -0400
Date: Wed, 29 Jun 2011 12:35:28 +0400
From: Kirill Smelkov <kirr@mns.spb.ru>
To: Dan Carpenter <error27@gmail.com>, Tomas Winkler <tomas.winkler@intel.com>
Cc: Greg Kroah-Hartman <gregkh@suse.de>, devel@driverdev.osuosl.org,
        Mike Thomas <rmthomas@sciolus.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/5] staging/easycap: Fix thinko in "bars" module
	option description
Message-ID: <20110629083528.GA10219@tugrik.mns.mnsspb.ru>
References: <cover.1307967011.git.kirr@mns.spb.ru> <14c0e4d0bb7ef1a05b9dcc14b2b51c706f844655.1307967011.git.kirr@mns.spb.ru> <20110613122717.GF3583@shale.localdomain> <20110614164649.GB29015@tugrik.mns.mnsspb.ru> <20110614171619.GB23739@shale.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110614171619.GB23739@shale.localdomain>
Organization: Marine Bridge & Navigation Systems
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 14, 2011 at 08:16:19PM +0300, Dan Carpenter wrote:
> On Tue, Jun 14, 2011 at 08:46:49PM +0400, Kirill Smelkov wrote:
> > On Mon, Jun 13, 2011 at 03:27:17PM +0300, Dan Carpenter wrote:
> > > On Mon, Jun 13, 2011 at 04:18:29PM +0400, Kirill Smelkov wrote:
> > > > Both bars=0 and bars=1 were described as meaning to display bars on
> > > > signal lost. Actually bars=1 means "display bars", but bars=0 means
> > > > display raw source as is (usually black screen).
> > > 
> > > Your description up here is much better than the one in the README.
> > > Maybe just include yours and delete the original.
> > 
> > Thanks for head ups. Something like this:
> >
> 
> I like it.  :)

Thanks. So I assume this version is better to go in. Tomas, may I add
your ACK to this one, or maybe there is some issue with it?


Thanks,
Kirill


P.S. By the way, how should we proceed to get this merged into staging
tree? Will Greg just pick it up or should I repost the whole series?
