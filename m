Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754976Ab1HBTeu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Aug 2011 15:34:50 -0400
Received: from www17.your-server.de ([213.133.104.17]:45825 "EHLO
	www17.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754708Ab1HBTep (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Aug 2011 15:34:45 -0400
Subject: Re: [PATCH] Use kstrdup rather than duplicating its implementation
From: Thomas Meyer <thomas@m3y3r.de>
To: Dan Carpenter <error27@gmail.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        kernel-janitors@vger.kernel.org
Date: Tue, 02 Aug 2011 21:34:14 +0200
In-Reply-To: <20110802180537.GB3839@shale.localdomain>
References: <1312302089.2629.15.camel@localhost.localdomain>
	 <20110802180537.GB3839@shale.localdomain>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.0.2 (3.0.2-3.fc15) 
Content-Transfer-Encoding: 7bit
Message-ID: <1312313657.2629.20.camel@localhost.localdomain>
Mime-Version: 1.0
X-Authenticated-Sender: thomas@m3y3r.de
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Dienstag, den 02.08.2011, 21:05 +0300 schrieb Dan Carpenter:
> On Tue, Aug 02, 2011 at 06:21:26PM +0200, Thomas Meyer wrote:
> >  The semantic patch that makes this output is available
> >  in scripts/coccinelle/api/kstrdup.cocci.
> > 
> >  More information about semantic patching is available at
> >  http://coccinelle.lip6.fr/
> > 
> 
> These should be sent individually, because the chunks need to go into
> a bunch of separate trees before they get merged into the official
> kernel.  (One change per file basically on this).
> 

Does somebody maybe have a script for doing this split of an mbox file?
maybe this script could also call get_maintainer.pl and change the To:
field accordingly?

Just asking...




