Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932724Ab2BOCdr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Feb 2012 21:33:47 -0500
Received: from out5-smtp.messagingengine.com ([66.111.4.29]:49301 "EHLO
	out5-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932129Ab2BOCdp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Feb 2012 21:33:45 -0500
X-Sasl-enc: T3lQPAUfwIXVhKlbkZ808S810fPy0H0j2nY9RZqixMWj 1329273223
Date: Tue, 14 Feb 2012 18:33:31 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: Dan Magenheimer <dan.magenheimer@oracle.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Seth Jennings <sjenning@linux.vnet.ibm.com>,
        Nitin Gupta <ngupta@vflare.org>, Konrad Wilk <konrad.wilk@oracle.com>
Subject: Re: linux-next: build failure after merge of the staging tree
Message-ID: <20120215023331.GA28786@kroah.com>
References: <20120210155800.ccef418fd5c2f2b87a5d6315@canb.auug.org.au>
 <20120210052947.GA2068@kroah.com>
 <80f07411-179e-4fe9-b591-32fbcaac414b@default>
 <20120210174359.GB5128@kroah.com>
 <443c718c-643b-4b48-9dd8-e0424fc0afa9@default>
 <20120215000358.GA27341@kroah.com>
 <e0be2242-530b-46cd-ad3a-d49fd60345ab@default>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <e0be2242-530b-46cd-ad3a-d49fd60345ab@default>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 14, 2012 at 04:54:37PM -0800, Dan Magenheimer wrote:
> > From: Greg KH [mailto:gregkh@linuxfoundation.org]
> > Subject: Re: linux-next: build failure after merge of the staging tree
> > 
> > > > Ok, now reverted, what a mess...
> > > >
> > > > greg k-h
> > >
> > > OK, I have just posted the ramster v5 patchset which applies against
> > > linux-3.2.  I've test-built it against linux-next... it only gets
> > > the normal minor merge conflicts for adding a line to
> > > drivers/staging/Makefile and Kconfig.
> > 
> > Please resend after fixing that conflict, as it would require me to edit
> > it by hand in order to apply this.  As you have already redone the
> > patch, there's no reason I should have to do this, right?
> 
> OK.  I'm not quite sure how to generate a patchset or a
> git commit-set that applies cleanly against two different
> trees (3.2 and linux-next), but I guess common sense should
> tell me that, since the patches have to go through staging-next
> first and you are applying patches rather than git-pull'ing,
> staging-next should be my preferred choice for a base.

Exactly, how could I apply them to two trees?  For that case, how can I
go back in time and apply them to 3.2?

> Do you want me to resend all 6 patches?  The only patch
> affected is patch 6 of 6.  All others apply cleanly.
> Let me know and I will resend one or all tomorrow.

All would be best, also please thread them properly, 'git send-email'
will do this for you, please use it.

greg k-h
