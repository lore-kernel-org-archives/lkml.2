Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755879Ab0C3INd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Mar 2010 04:13:33 -0400
Received: from cantor.suse.de ([195.135.220.2]:35697 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754186Ab0C3INb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Mar 2010 04:13:31 -0400
Date: Tue, 30 Mar 2010 10:13:29 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
To: Oliver Neukum <oliver@neukum.org>
Cc: Greg KH <greg@kroah.com>, USB list <linux-usb@vger.kernel.org>,
       Mauro Carvalho Chehab <mchehab@infradead.org>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 4/5] usb:Push BKL on open down into the drivers
In-Reply-To: <201003300846.59307.oliver@neukum.org>
Message-ID: <alpine.LNX.2.00.1003301013160.24576@pobox.suse.cz>
References: <201001131533.15704.oliver@neukum.org> <201003291530.37183.oliver@neukum.org> <alpine.LNX.2.00.1003291546040.24576@pobox.suse.cz> <201003300846.59307.oliver@neukum.org>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 30 Mar 2010, Oliver Neukum wrote:

> > > This is not a nice feature of the BKL to use. Do you have an alternative 
> > > idea?
> > 
> > Not right now, without introducing additional lock into USB core or 
> > redesigning the hiddev node registration completely. Hmmm ...
> 
> Then you might want to add a comment so the next developer who wants to
> eradicate BKL is warned.

That I already have in my tree.

Thanks,

-- 
Jiri Kosina
SUSE Labs, Novell Inc.
