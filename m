Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752927Ab0K2UB0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Nov 2010 15:01:26 -0500
Received: from lennier.cc.vt.edu ([198.82.162.213]:52194 "EHLO
	lennier.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750742Ab0K2UBY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Nov 2010 15:01:24 -0500
X-Mailer: exmh version 2.7.2 01/07/2005 with nmh-1.2
To: Joerg Roedel <joro@8bytes.org>
Cc: "Roedel, Joerg" <Joerg.Roedel@amd.com>, Avi Kivity <avi@redhat.com>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 0/9] KVM: Make the instruction emulator aware of Nested Virtualization
In-Reply-To: Your message of "Mon, 29 Nov 2010 19:32:12 +0100."
             <20101129183212.GD15575@8bytes.org>
From: Valdis.Kletnieks@vt.edu
References: <1290622715-8382-1-git-send-email-joerg.roedel@amd.com> <4CED63DC.20608@redhat.com> <20101125114640.GC6031@amd.com> <20101125131351.GA9382@amd.com> <4CEE7E21.3060007@redhat.com> <20101125162313.GA9411@amd.com> <11557.1291051418@localhost>
            <20101129183212.GD15575@8bytes.org>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1291060870_5346P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Mon, 29 Nov 2010 15:01:10 -0500
Message-ID: <18726.1291060870@localhost>
X-Mirapoint-Received-SPF: 128.173.14.107 localhost Valdis.Kletnieks@vt.edu 2 pass
X-Mirapoint-IP-Reputation: reputation=neutral-1,
	source=Fixed,
	refid=n/a,
	actions=MAILHURDLE SPF TAG
X-Junkmail-Status: score=10/50, host=dagger.cc.vt.edu
X-Junkmail-Signature-Raw: score=unknown,
	refid=str=0001.0A020208.4CF40687.029B,ss=1,fgs=0,
	ip=0.0.0.0,
	so=2010-07-22 22:03:31,
	dmn=2009-09-10 00:05:08,
	mode=single engine
X-Junkmail-IWF: false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1291060870_5346P
Content-Type: text/plain; charset=us-ascii

On Mon, 29 Nov 2010 19:32:12 +0100, Joerg Roedel said:
> On Mon, Nov 29, 2010 at 12:23:38PM -0500, Valdis.Kletnieks@vt.edu wrote:
> > (Sorry for late reply...)
> > 
> > On Thu, 25 Nov 2010 17:23:13 +0100, "Roedel, Joerg" said:
> > > On Thu, Nov 25, 2010 at 10:17:53AM -0500, Avi Kivity wrote:
> > > > On 11/25/2010 03:13 PM, Roedel, Joerg wrote:
> > > > What about things like adding instructions and forgetting to add the 
> > > > corresponding svm.c code?
> > > Cannot happen. Every instruction that can be intercepted with SVM is
> > > already handled in this patch-set.
> > 
> > Call us back when Intel releases the i9 and i11 with new instructions
> > that need intercept handling. ;)
> 
> How does that affect SVM?

It will quite possibly include instructions that can be intercepted with SVM
that are not in this patch set.  At which point Joerg's comment can apply - it
will be possible to add it in one place and forget to add it in the svm.c code.


--==_Exmh_1291060870_5346P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iD8DBQFM9AaGcC3lWbTT17ARAlNOAJ46WdcR1TvJghPcrrfOQp3yGsXHIACeM0Gt
9BtXi+HTybXsHjh9A6vt6LY=
=xygP
-----END PGP SIGNATURE-----

--==_Exmh_1291060870_5346P--

