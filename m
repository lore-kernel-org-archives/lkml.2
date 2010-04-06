Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757370Ab0DFRve (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Apr 2010 13:51:34 -0400
Received: from va3ehsobe001.messaging.microsoft.com ([216.32.180.11]:43889
	"EHLO VA3EHSOBE001.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753146Ab0DFRv1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Apr 2010 13:51:27 -0400
X-SpamScore: -18
X-BigFish: VPS-18(zz1432P98dN936eMzz1202hzzz32i87h6bh2a8h43h61h)
X-Spam-TCS-SCL: 0:0
X-FB-SS: 5,
X-FB-DOMAIN-IP-MATCH: fail
X-WSS-ID: 0L0GUX8-01-4EN-02
X-M-MSG: 
Date: Tue, 6 Apr 2010 19:51:06 +0200
From: Joerg Roedel <joerg.roedel@amd.com>
To: Chris Wright <chrisw@sous-sol.org>
CC: Joerg Roedel <joro@8bytes.org>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Bernhard Walle <bernhard@bwalle.de>, nhorman@redhat.com,
       nhorman@tuxdriver.com, kexec@lists.infradead.org,
       linux-kernel@vger.kernel.org, hbabu@us.ibm.com,
       iommu@lists.linux-foundation.org, vgoyal@redhat.com
Subject: Re: [PATCH 3/4] Revert "x86: disable IOMMUs on kernel crash"
Message-ID: <20100406175106.GH28166@amd.com>
References: <20100403012751.834020949@sous-sol.org>
 <20100403012820.229410717@sous-sol.org>
 <20100403174128.GQ24846@8bytes.org>
 <m1vdc8juju.fsf@fess.ebiederm.org>
 <4BB83EAE.5090609@bwalle.de>
 <20100404085338.GU24846@8bytes.org>
 <m17hond01n.fsf@fess.ebiederm.org>
 <20100404100101.GW24846@8bytes.org>
 <20100406174257.GG29241@sequoia.sous-sol.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20100406174257.GG29241@sequoia.sous-sol.org>
Organization: Advanced Micro Devices =?iso-8859-1?Q?GmbH?=
	=?iso-8859-1?Q?=2C_Karl-Hammerschmidt-Str=2E_34=2C_85609_Dornach_bei_M=FC?=
	=?iso-8859-1?Q?nchen=2C_Gesch=E4ftsf=FChrer=3A_Thomas_M=2E_McCoy=2C_Giuli?=
	=?iso-8859-1?Q?ano_Meroni=2C_Andrew_Bowd=2C_Sitz=3A_Dornach=2C_Gemeinde_A?=
	=?iso-8859-1?Q?schheim=2C_Landkreis_M=FCnchen=2C_Registergericht_M=FCnche?=
	=?iso-8859-1?Q?n=2C?= HRB Nr. 43632
User-Agent: Mutt/1.5.20 (2009-06-14)
X-OriginalArrivalTime: 06 Apr 2010 17:51:06.0949 (UTC) FILETIME=[BBC26F50:01CAD5B1]
X-Reverse-DNS: unknown
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 06, 2010 at 10:42:57AM -0700, Chris Wright wrote:
> * Joerg Roedel (joro@8bytes.org) wrote:
> > On Sun, Apr 04, 2010 at 02:44:36AM -0700, Eric W. Biederman wrote:
> > > Joerg Roedel <joro@8bytes.org> writes:
> > > 
> > > > On Sun, Apr 04, 2010 at 09:24:30AM +0200, Bernhard Walle wrote:
> > > >> Am 03.04.10 19:49, schrieb Eric W. Biederman:
> > > >> > Not a problem.  We require a lot of things of the kdump kernel,
> > > >> > and it is immediately apparent in a basic sanity test.
> > > >> 
> > > >> Also, in most cases (for example: distribution kernels), the kdump
> > > >> kernel nowadays is identical to the running kernel. So, if the running
> > > >> kernel has IOMMU support, the kdump kernel also has.
> > > >
> > > > Yes, I know. But is that a requirement for kexec?
> > > 
> > > For normal kexec no.  That path is expected to do a clean hardware
> > > shutdown.
> > > 
> > > For kexec on panic aka kdump the requirement is that your your crash
> > > kernel be able to initialize your hardware from any state it can be
> > > put in.
> > 
> > Ok, if you show me where this is documented for everybody then I am
> > probably convinced :-)
> > We should fixup the gart initialization anyway.
> 
> So, you planning to pull in all 4 patches then?

Yes, I will apply them tomorrow and write a fix for the GART issue this
may introduce.

	Joerg


