Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755944Ab1EKPyF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 May 2011 11:54:05 -0400
Received: from kroah.org ([198.145.64.141]:43973 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755664Ab1EKPyC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 May 2011 11:54:02 -0400
Date: Wed, 11 May 2011 07:56:34 -0700
From: Greg KH <greg@kroah.com>
To: Maxin B John <maxin.john@gmail.com>
Cc: Erik Slagter <erik@slagter.name>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 001/001]: USB: cdc_acm: Fix oops when Droids MuIn LCD is
 connected
Message-ID: <20110511145634.GB18317@kroah.com>
References: <20110510074421.GA2755@maxin>
 <4DC97BD0.6040403@slagter.name>
 <BANLkTi=OQ=ahXW2n=ww4ZZ8vK4=mv6Kc7A@mail.gmail.com>
 <4DCA5FBF.1050009@slagter.name>
 <20110511134730.GA12717@kroah.com>
 <BANLkTi=ty_LMx4mvRXt5v=6-TxUyZir4oA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <BANLkTi=ty_LMx4mvRXt5v=6-TxUyZir4oA@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 11, 2011 at 03:13:37PM +0100, Maxin B John wrote:
> Hi Greg,
> 
> > If Maxin created it, it should have his "From:" on the top, right?
> 
> It was a combined effort. I think, Erik has done the core part of it.

Ok, and from an email I just got from Erik, that's fine.

> > And did Maxin really sign-off-by: on the patch?  You can not add other
> > people's names to that without them really doing it, that's not allowed
> > at all.
> 
> Yes. I have added the "sign-off-by:" by myself. While we were developing and
> testing the patch, we have agreed to share the fame/blame together.

Ok, I wasn't aware of this.

> > Care to redo it?
> Should we really re-do it for the "sign-off-by" issue ? If it is
> really required,
> we are ready to redo it.

No, that's fine, I was not aware that both of you agreed to this.  I'll
add it to my "to-apply" queue and you will get an automated email when
it is applied to the tree.

thanks,

greg k-h
