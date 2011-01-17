Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753359Ab1AQLvz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Jan 2011 06:51:55 -0500
Received: from va3ehsobe001.messaging.microsoft.com ([216.32.180.11]:55960
	"EHLO VA3EHSOBE001.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751985Ab1AQLvx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Jan 2011 06:51:53 -0500
X-SpamScore: -39
X-BigFish: VPS-39(zzbb2dKbb2cK1432N98dN4015L9371Pzz1202hzz15d4Rz32i637h668h)
X-Forefront-Antispam-Report: KIP:(null);UIP:(null);IPVD:NLI;H:ausb3twp01.amd.com;RD:none;EFVD:NLI
X-WSS-ID: 0LF6058-01-8QJ-02
X-M-MSG: 
Date: Mon, 17 Jan 2011 12:34:21 +0100
From: "Roedel, Joerg" <Joerg.Roedel@amd.com>
To: Avi Kivity <avi@redhat.com>
CC: Joerg Roedel <joro@8bytes.org>, Marcelo Tosatti <mtosatti@redhat.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 0/2 v2] perf-kvm support for SVM
Message-ID: <20110117113421.GC31122@amd.com>
References: <1295019902-31339-1-git-send-email-joerg.roedel@amd.com>
 <4D32CD45.3090503@redhat.com>
 <20110116153506.GI6376@8bytes.org>
 <4D3310E3.9020909@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <4D3310E3.9020909@redhat.com>
Organization: Advanced Micro Devices =?iso-8859-1?Q?GmbH?=
	=?iso-8859-1?Q?=2C_Karl-Hammerschmidt-Str=2E_34=2C_85609_Dornach_bei_M=FC?=
	=?iso-8859-1?Q?nchen=2C_Gesch=E4ftsf=FChrer=3A_Thomas_M=2E_McCoy=2C_Giuli?=
	=?iso-8859-1?Q?ano_Meroni=2C_Andrew_Bowd=2C_Sitz=3A_Dornach=2C_Gemeinde_A?=
	=?iso-8859-1?Q?schheim=2C_Landkreis_M=FCnchen=2C_Registergericht_M=FCnche?=
	=?iso-8859-1?Q?n=2C?= HRB Nr. 43632
User-Agent: Mutt/1.5.20 (2009-06-14)
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jan 16, 2011 at 10:38:11AM -0500, Avi Kivity wrote:
> On 01/16/2011 05:35 PM, Joerg Roedel wrote:
> > On Sun, Jan 16, 2011 at 12:49:41PM +0200, Avi Kivity wrote:
> > >  On 01/14/2011 05:45 PM, Joerg Roedel wrote:
> >
> > >>  here is the reworked version of the patch-set. Only patch 1/2 has
> > >>  changed and now contains the real fix for the crashes that were seen and
> > >>  has an updated log message.
> > >>
> > >
> > >  Thanks, applied.  2.6.37 and earlier aren't affected, yes?  So I'm
> > >  queuing it for 2.6.38 only.
> >
> > I think the problem is there since KVM has lazy state switching. So the
> > fix in patch 1 should make it in all currently maintained stable-trees.
> >
> 
> The problem is with load_gs_index(), yes?  In 2.6.37 this is called 
> before stgi(), so it's protected from nmi.

Ok, you are right :) So the fix is only necessary for 2.6.38.

	Joerg

-- 
AMD Operating System Research Center

Advanced Micro Devices GmbH Einsteinring 24 85609 Dornach
General Managers: Alberto Bozzo, Andrew Bowd
Registration: Dornach, Landkr. Muenchen; Registerger. Muenchen, HRB Nr. 43632

