Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757844Ab0E0KXT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 May 2010 06:23:19 -0400
Received: from tx2ehsobe004.messaging.microsoft.com ([65.55.88.14]:11531 "EHLO
	TX2EHSOBE008.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757336Ab0E0KXR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 May 2010 06:23:17 -0400
X-SpamScore: -13
X-BigFish: VPS-13(zz1432P98dNzz1202hzzz32i2a8h87h43h61h)
X-Spam-TCS-SCL: 0:0
X-FB-DOMAIN-IP-MATCH: fail
X-WSS-ID: 0L32Q17-02-0VG-02
X-M-MSG: 
Date: Thu, 27 May 2010 12:19:58 +0200
From: "Roedel, Joerg" <Joerg.Roedel@amd.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
CC: Avi Kivity <avi@qumranet.com>, Marcelo Tosatti <mtosatti@redhat.com>,
       "linux-next@vger.kernel.org" <linux-next@vger.kernel.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: linux-next: build warning after merge of the kvm tree
Message-ID: <20100527101957.GT3266@amd.com>
References: <20100527145307.0e6d537c.sfr@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20100527145307.0e6d537c.sfr@canb.auug.org.au>
Organization: Advanced Micro Devices =?iso-8859-1?Q?GmbH?=
	=?iso-8859-1?Q?=2C_Karl-Hammerschmidt-Str=2E_34=2C_85609_Dornach_bei_M=FC?=
	=?iso-8859-1?Q?nchen=2C_Gesch=E4ftsf=FChrer=3A_Thomas_M=2E_McCoy=2C_Giuli?=
	=?iso-8859-1?Q?ano_Meroni=2C_Andrew_Bowd=2C_Sitz=3A_Dornach=2C_Gemeinde_A?=
	=?iso-8859-1?Q?schheim=2C_Landkreis_M=FCnchen=2C_Registergericht_M=FCnche?=
	=?iso-8859-1?Q?n=2C?= HRB Nr. 43632
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Reverse-DNS: unknown
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 27, 2010 at 12:53:07AM -0400, Stephen Rothwell wrote:
> After merging the kvm tree, today's linux-next build (x86_64 allmodconfig)
> produced this warning:
> 
> arch/x86/kvm/svm.c: In function 'svm_handle_mce':
> arch/x86/kvm/svm.c:1489: warning: unused variable 'kvm_run'
> 
> Introduced by commit 5c91e7b615f7b6b36f6ad32356bb786bed5b7764 ("KVM: SVM:
> Implement workaround for Erratum 383").

Fix for that is already posted and should be in the KVM tree soon.

	Joerg


