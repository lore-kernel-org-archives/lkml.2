Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758103Ab2DYKfV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Apr 2012 06:35:21 -0400
Received: from db3ehsobe001.messaging.microsoft.com ([213.199.154.139]:30805
	"EHLO db3outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756970Ab2DYKfT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Apr 2012 06:35:19 -0400
X-SpamScore: -3
X-BigFish: VPS-3(zz98dKzz1202hzzz2dh668h839h944hd25h)
X-Forefront-Antispam-Report: CIP:163.181.249.109;KIP:(null);UIP:(null);IPV:NLI;H:ausb3twp02.amd.com;RD:none;EFVD:NLI
X-WSS-ID: 0M316QG-02-6X4-02
X-M-MSG: 
Date: Wed, 25 Apr 2012 12:35:00 +0200
From: Borislav Petkov <borislav.petkov@amd.com>
To: Ingo Molnar <mingo@kernel.org>
CC: Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
        <x86@kernel.org>, <kernel-janitors@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>,
        "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>,
        Frank Arnold <frank.arnold@amd.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Dan Carpenter <dan.carpenter@oracle.com>
Subject: Re: [GIT PULL] L3 CID fix for 3.5
Message-ID: <20120425103500.GD18882@aftab.osrc.amd.com>
References: <20120419070053.GB16645@elgon.mountain>
 <4F8FCA3A.5060504@linux.vnet.ibm.com>
 <20120419110229.GB30447@aftab>
 <20120419114453.GO6498@mwanda>
 <20120419165353.GF3221@aftab.osrc.amd.com>
 <20120425093001.GA18882@aftab.osrc.amd.com>
 <20120425102357.GC20853@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20120425102357.GC20853@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 25, 2012 at 12:23:58PM +0200, Ingo Molnar wrote:
> Looks good to me. You marked it v3.5, should I pull it into v3.4?
> Looks small enough to me and we better keep such user facing
> interfaces correct, even if there's no direct regression.

I'm fine with whatever you decide,

thanks.

-- 
Regards/Gruss,
Boris.

Advanced Micro Devices GmbH
Einsteinring 24, 85609 Dornach
GM: Alberto Bozzo
Reg: Dornach, Landkreis Muenchen
HRB Nr. 43632 WEEE Registernr: 129 19551

