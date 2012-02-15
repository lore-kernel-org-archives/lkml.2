Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752510Ab2BOQPp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Feb 2012 11:15:45 -0500
Received: from acsinet15.oracle.com ([141.146.126.227]:46038 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751924Ab2BOQPn convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Feb 2012 11:15:43 -0500
MIME-Version: 1.0
Message-ID: <da7c3779-70a7-42f6-908f-f9b283410acd@default>
Date: Wed, 15 Feb 2012 08:14:52 -0800 (PST)
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
 <e0be2242-530b-46cd-ad3a-d49fd60345ab@default>
 <20120215023331.GA28786@kroah.com>
In-Reply-To: <20120215023331.GA28786@kroah.com>
X-Priority: 3
X-Mailer: Oracle Beehive Extensions for Outlook 2.0.1.6  (510070) [OL
 12.0.6607.1000 (x86)]
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
X-CT-RefId: str=0001.0A090205.4F3BDA04.001A,ss=1,re=0.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> From: Greg KH [mailto:gregkh@linuxfoundation.org]
> 
> On Tue, Feb 14, 2012 at 04:54:37PM -0800, Dan Magenheimer wrote:
> > > From: Greg KH [mailto:gregkh@linuxfoundation.org]
> > > Subject: Re: linux-next: build failure after merge of the staging tree
> > >
> > > > OK, I have just posted the ramster v5 patchset which applies against
> > > > linux-3.2.  I've test-built it against linux-next... it only gets
> > > > the normal minor merge conflicts for adding a line to
> > > > drivers/staging/Makefile and Kconfig.
> > >
> > > Please resend after fixing that conflict, as it would require me to edit
> > > it by hand in order to apply this.  As you have already redone the
> > > patch, there's no reason I should have to do this, right?
> >
> > Do you want me to resend all 6 patches?  The only patch
> > affected is patch 6 of 6.  All others apply cleanly.
> > Let me know and I will resend one or all tomorrow.
> 
> All would be best, also please thread them properly, 'git send-email'
> will do this for you, please use it.

OK, posted (*).  BTW, I _was_ using git send-email, just didn't know
that "git send-email patch0 patch1 patch2 ..." would cause them
to be threaded.  (I was using git send-email patch0;
git send-email patch1; git send-email patch2...)

Thanks again for your patience and help!  I think RAMster
can now be successfully queued with no linux-next merge issues!

Dan

* http://driverdev.linuxdriverproject.org/pipermail/devel/2012-February/024614.html
