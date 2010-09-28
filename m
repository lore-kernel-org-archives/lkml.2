Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760238Ab0I1JWu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Sep 2010 05:22:50 -0400
Received: from va3ehsobe006.messaging.microsoft.com ([216.32.180.16]:48918
	"EHLO VA3EHSOBE006.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753586Ab0I1JWs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Sep 2010 05:22:48 -0400
X-SpamScore: -32
X-BigFish: VS-32(zzbb2dK1432N98dN9371Pzz1202hzz15d4Rz32i87h2a8h61h)
X-Spam-TCS-SCL: 0:0
X-FB-DOMAIN-IP-MATCH: fail
X-WSS-ID: 0L9GA1O-01-5S8-02
X-M-MSG: 
Date: Tue, 28 Sep 2010 11:22:59 +0200
From: "Roedel, Joerg" <Joerg.Roedel@amd.com>
To: Avi Kivity <avi@redhat.com>
CC: "H. Peter Anvin" <hpa@zytor.com>, Alexander Graf <agraf@suse.de>,
        "x86@kernel.org" <x86@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>
Subject: Re: [PATCH] x86, nmi: workaround sti; hlt race vs nmi; intr
Message-ID: <20100928092258.GJ9817@amd.com>
References: <1284913699-14986-1-git-send-email-avi@redhat.com>
 <4CA057EA.7000609@redhat.com>
 <768A5DC0-131A-4BC8-ADDD-044D8169545E@suse.de>
 <61284934-1AD3-4F7A-9488-D46FCEE9B753@suse.de>
 <4CA06147.7080805@redhat.com>
 <C725B379-9631-46E4-A825-E43A5120681E@suse.de>
 <4CA06373.5030501@redhat.com>
 <4CA112D1.2020004@zytor.com>
 <4CA1AC50.7000801@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <4CA1AC50.7000801@redhat.com>
Organization: Advanced Micro Devices =?iso-8859-1?Q?GmbH?=
	=?iso-8859-1?Q?=2C_Karl-Hammerschmidt-Str=2E_34=2C_85609_Dornach_bei_M=FC?=
	=?iso-8859-1?Q?nchen=2C_Gesch=E4ftsf=FChrer=3A_Thomas_M=2E_McCoy=2C_Giuli?=
	=?iso-8859-1?Q?ano_Meroni=2C_Andrew_Bowd=2C_Sitz=3A_Dornach=2C_Gemeinde_A?=
	=?iso-8859-1?Q?schheim=2C_Landkreis_M=FCnchen=2C_Registergericht_M=FCnche?=
	=?iso-8859-1?Q?n=2C?= HRB Nr. 43632
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Reverse-DNS: ausb3extmailp02.amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 28, 2010 at 04:50:24AM -0400, Avi Kivity wrote:
>   On 09/27/2010 11:55 PM, H. Peter Anvin wrote:
> > On 09/27/2010 02:27 AM, Avi Kivity wrote:
> > >
> > >  I don't have write permissions for the spec.  If you can verify that all
> > >  existing and future hardware will mask NMI after STI and convince the
> > >  spec owners to update the specifications, I'm all for it; it's certainly
> > >  a cleaner solution.
> > >
> >
> > I'm trying to see if this is doable.  As you can well imagine, though,
> > it takes time.
> 
> Joerg, can you look at this from the AMD side?

Yes, I will discuss this with the hardware peoples. Will take some time
here too.

	Joerg

-- 
AMD Operating System Research Center

Advanced Micro Devices GmbH Einsteinring 24 85609 Dornach
General Managers: Alberto Bozzo, Andrew Bowd
Registration: Dornach, Landkr. Muenchen; Registerger. Muenchen, HRB Nr. 43632

