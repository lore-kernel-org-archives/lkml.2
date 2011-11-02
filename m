Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752884Ab1KBWyO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Nov 2011 18:54:14 -0400
Received: from swampdragon.chaosbits.net ([90.184.90.115]:26661 "EHLO
	swampdragon.chaosbits.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750889Ab1KBWyN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Nov 2011 18:54:13 -0400
Date: Wed, 2 Nov 2011 23:59:17 +0100 (CET)
From: Jesper Juhl <jj@chaosbits.net>
To: Dan Carpenter <dan.carpenter@oracle.com>
cc: "K. Y. Srinivasan" <kys@microsoft.com>, dmitry.torokhov@gmail.com,
        jkosina@suse.cz, gregkh@suse.de, ohering@suse.com,
        linux-kernel@vger.kernel.org, virtualization@lists.osdl.org,
        joe@perches.com, devel@linuxdriverproject.org
Subject: Re: [PATCH 1/1] Staging: hv: Move the mouse driver out of staging
In-Reply-To: <20111029063240.GH14881@longonot.mountain>
Message-ID: <alpine.LNX.2.00.1111022353530.20903@swampdragon.chaosbits.net>
References: <1319841316-29136-1-git-send-email-kys@microsoft.com> <alpine.LNX.2.00.1110290041500.31615@swampdragon.chaosbits.net> <20111029063240.GH14881@longonot.mountain>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 29 Oct 2011, Dan Carpenter wrote:

> On Sat, Oct 29, 2011 at 12:54:34AM +0200, Jesper Juhl wrote:
> > > +			default:
> > > +				pr_err("unhandled packet type %d, tid %llx len %d\n",
> > > +				   desc->type,
> > > +				   req_id,
> > > +				   bytes_recvd);
> > 
> > Why not:
> > 
> >                                 pr_err("unhandled packet type %d, tid %llx 
> >                                        len %d\n", desc->type, req_id, bytes_recvd);
> 
> Because then the printk would be messed up?  Your final printed
> string would look like:
> 
> "unhandled packet type %d, tid %llx 
>                                        len %d\n"
> 
> Don't break strings up across lines because it breaks grep.  If K. Y.
> wants to put all the parameters on one line instead of three that
> would probably be better, but in the end who cares?
> 
Right, so I obviously "fat fingered" that and should have read my email 
once more before sending. *But* the point really was just the "put all the 
parameters on one line rather than 3" bit...

As for who cares; well, I cared enough to actually read the patch and send 
a reply, and I thought we needed more reviewers... When I review something 
I comment on everything I spot from bugs to trivial stuff - then it is 
up to the recipient to pick the things they want to address from the 
reply..

-- 
Jesper Juhl <jj@chaosbits.net>       http://www.chaosbits.net/
Don't top-post http://www.catb.org/jargon/html/T/top-post.html
Plain text mails only, please.

