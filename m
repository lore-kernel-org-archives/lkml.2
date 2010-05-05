Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760484Ab0EEPQk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 May 2010 11:16:40 -0400
Received: from tx2ehsobe001.messaging.microsoft.com ([65.55.88.11]:4249 "EHLO
	TX2EHSOBE001.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760431Ab0EEPQi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 May 2010 11:16:38 -0400
X-SpamScore: -29
X-BigFish: VPS-29(zz146fK1432P98dN936eM9371Pzz1202hzzz32i2a8h87h62h)
X-Spam-TCS-SCL: 1:0
X-FB-DOMAIN-IP-MATCH: fail
X-WSS-ID: 0L1YD32-02-4GU-02
X-M-MSG: 
Date: Wed, 5 May 2010 17:16:16 +0200
From: "Roedel, Joerg" <Joerg.Roedel@amd.com>
To: Avi Kivity <avi@redhat.com>
CC: Joerg Roedel <joro@8bytes.org>, Marcelo Tosatti <mtosatti@redhat.com>,
       "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 4/5] KVM: SVM: Allow EFER.LMSLE to be set with nested
 svm
Message-ID: <20100505151615.GD7515@amd.com>
References: <1273068285-3105-1-git-send-email-joerg.roedel@amd.com>
 <1273068285-3105-5-git-send-email-joerg.roedel@amd.com>
 <4BE184E3.1010508@redhat.com>
 <20100505150406.GF14542@8bytes.org>
 <4BE18993.50306@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <4BE18993.50306@redhat.com>
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

On Wed, May 05, 2010 at 11:06:59AM -0400, Avi Kivity wrote:
> On 05/05/2010 06:04 PM, Joerg Roedel wrote:
> > You can roughly check
> > for it using the svm cpuid bit.
> 
> Doesn't it kill cross-vendor migration?

Enabling Nested SVM kills it anyway, so this is not an issue. AFAIK the
feature is not present on Intel CPUs.

	Joerg


