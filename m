Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754066Ab0DWO3L (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Apr 2010 10:29:11 -0400
Received: from tx2ehsobe003.messaging.microsoft.com ([65.55.88.13]:5879 "EHLO
	TX2EHSOBE006.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753848Ab0DWO3F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Apr 2010 10:29:05 -0400
X-SpamScore: -18
X-BigFish: VPS-18(zz1432P98dN936eMzz1202hzzz32i87h2a8h62h)
X-Spam-TCS-SCL: 1:0
X-FB-DOMAIN-IP-MATCH: fail
X-WSS-ID: 0L1C2W4-02-984-02
X-M-MSG: 
Date: Fri, 23 Apr 2010 16:28:50 +0200
From: Joerg Roedel <joerg.roedel@amd.com>
To: Alexander Graf <agraf@suse.de>
CC: Avi Kivity <avi@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>,
       kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 8/8] KVM: SVM: Handle MCE intercepts always on host
 level
Message-ID: <20100423142850.GI31537@amd.com>
References: <1271932394-13968-1-git-send-email-joerg.roedel@amd.com>
 <1271932394-13968-9-git-send-email-joerg.roedel@amd.com>
 <2316FEB4-9D50-436E-B29F-C6B43970AC9A@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <2316FEB4-9D50-436E-B29F-C6B43970AC9A@suse.de>
Organization: Advanced Micro Devices =?iso-8859-1?Q?GmbH?=
	=?iso-8859-1?Q?=2C_Karl-Hammerschmidt-Str=2E_34=2C_85609_Dornach_bei_M=FC?=
	=?iso-8859-1?Q?nchen=2C_Gesch=E4ftsf=FChrer=3A_Thomas_M=2E_McCoy=2C_Giuli?=
	=?iso-8859-1?Q?ano_Meroni=2C_Andrew_Bowd=2C_Sitz=3A_Dornach=2C_Gemeinde_A?=
	=?iso-8859-1?Q?schheim=2C_Landkreis_M=FCnchen=2C_Registergericht_M=FCnche?=
	=?iso-8859-1?Q?n=2C?= HRB Nr. 43632
User-Agent: Mutt/1.5.20 (2009-06-14)
X-OriginalArrivalTime: 23 Apr 2010 14:28:50.0848 (UTC) FILETIME=[4B1A2200:01CAE2F1]
X-Reverse-DNS: ausb3extmailp02.amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 23, 2010 at 03:58:18PM +0200, Alexander Graf wrote:
> 
> On 22.04.2010, at 12:33, Joerg Roedel wrote:
> 
> > This patch prevents MCE intercepts from being propagated
> > into the L1 guest if they happened in an L2 guest.
> 
> Good catch. How did you stumble over this?

While thinking about another issue which I can't disclose
right now ;-) Stay tuned...

	Joerg


