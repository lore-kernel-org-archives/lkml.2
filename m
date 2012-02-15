Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761362Ab2BOAy4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Feb 2012 19:54:56 -0500
Received: from rcsinet15.oracle.com ([148.87.113.117]:18294 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755651Ab2BOAyy convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Feb 2012 19:54:54 -0500
MIME-Version: 1.0
Message-ID: <e0be2242-530b-46cd-ad3a-d49fd60345ab@default>
Date: Tue, 14 Feb 2012 16:54:37 -0800 (PST)
From: Dan Magenheimer <dan.magenheimer@oracle.com>
To: Greg KH <gregkh@linuxfoundation.org>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Seth Jennings <sjenning@linux.vnet.ibm.com>,
        Nitin Gupta <ngupta@vflare.org>, Konrad Wilk <konrad.wilk@oracle.com>
Subject: RE: linux-next: build failure after merge of the staging tree
References: <20120210155800.ccef418fd5c2f2b87a5d6315@canb.auug.org.au>
 <20120210052947.GA2068@kroah.com>
 <80f07411-179e-4fe9-b591-32fbcaac414b@default>
 <20120210174359.GB5128@kroah.com>
 <443c718c-643b-4b48-9dd8-e0424fc0afa9@default>
 <20120215000358.GA27341@kroah.com>
In-Reply-To: <20120215000358.GA27341@kroah.com>
X-Priority: 3
X-Mailer: Oracle Beehive Extensions for Outlook 2.0.1.6  (510070) [OL
 12.0.6607.1000 (x86)]
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
X-CT-RefId: str=0001.0A090208.4F3B0256.0001,ss=1,re=0.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> From: Greg KH [mailto:gregkh@linuxfoundation.org]
> Subject: Re: linux-next: build failure after merge of the staging tree
> 
> > > Ok, now reverted, what a mess...
> > >
> > > greg k-h
> >
> > OK, I have just posted the ramster v5 patchset which applies against
> > linux-3.2.  I've test-built it against linux-next... it only gets
> > the normal minor merge conflicts for adding a line to
> > drivers/staging/Makefile and Kconfig.
> 
> Please resend after fixing that conflict, as it would require me to edit
> it by hand in order to apply this.  As you have already redone the
> patch, there's no reason I should have to do this, right?

OK.  I'm not quite sure how to generate a patchset or a
git commit-set that applies cleanly against two different
trees (3.2 and linux-next), but I guess common sense should
tell me that, since the patches have to go through staging-next
first and you are applying patches rather than git-pull'ing,
staging-next should be my preferred choice for a base.

Do you want me to resend all 6 patches?  The only patch
affected is patch 6 of 6.  All others apply cleanly.
Let me know and I will resend one or all tomorrow.

Sorry for the noise/hassle, but this is a learning process...

Dan
