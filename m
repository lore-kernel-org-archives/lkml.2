Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757891Ab0HDNNl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Aug 2010 09:13:41 -0400
Received: from tx2ehsobe003.messaging.microsoft.com ([65.55.88.13]:39719 "EHLO
	TX2EHSOBE005.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757602Ab0HDNNk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Aug 2010 09:13:40 -0400
X-SpamScore: -25
X-BigFish: VS-25(z21eRz98dNzz1202hzz15d4Rz32i2a8h87h62h)
X-Spam-TCS-SCL: 1:0
X-FB-DOMAIN-IP-MATCH: fail
X-WSS-ID: 0L6MQ24-01-JBA-02
X-M-MSG: 
Date: Wed, 4 Aug 2010 15:16:34 +0200
From: "Roedel, Joerg" <Joerg.Roedel@amd.com>
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
CC: "subrata@linux.vnet.ibm.com" <subrata@linux.vnet.ibm.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Linuxppc-dev@ozlabs.org" <Linuxppc-dev@ozlabs.org>,
        "grant.likely@secretlab.ca" <grant.likely@secretlab.ca>,
        "James.Bottomley@suse.de" <James.Bottomley@suse.de>,
        "brking@linux.vnet.ibm.com" <brking@linux.vnet.ibm.com>,
        "tj@kernel.org" <tj@kernel.org>,
        "rcj@linux.vnet.ibm.com" <rcj@linux.vnet.ibm.com>,
        "devilbis@us.ibm.com" <devilbis@us.ibm.com>,
        "santil@us.ibm.com" <santil@us.ibm.com>,
        "sleddog@us.ibm.com" <sleddog@us.ibm.com>,
        "sachinp@linux.vnet.ibm.com" <sachinp@linux.vnet.ibm.com>,
        "dipraksh@linux.vnet.ibm.com" <dipraksh@linux.vnet.ibm.com>
Subject: Re: 2.6.35-stable/ppc64/p7: Badness at lib/dma-debug.c:902, Call
 Trace	& Instruction Dump during boot
Message-ID: <20100804131634.GX26098@amd.com>
References: <1280746270.15317.16.camel@subratamodak.linux.ibm.com>
 <20100802205404C.fujita.tomonori@lab.ntt.co.jp>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20100802205404C.fujita.tomonori@lab.ntt.co.jp>
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

On Mon, Aug 02, 2010 at 07:55:03AM -0400, FUJITA Tomonori wrote:
> I guess that this driver does a partial sync with
> dma_sync_single_for_* API. dma-debug can't handle it properly. It's
> likely that this is a false warning.

If this turns out to be true it is not trivial to fix. I prepare a patch
to test for you.

	Joerg

-- 
AMD Operating System Research Center

Advanced Micro Devices GmbH Einsteinring 24 85609 Dornach
General Managers: Alberto Bozzo, Andrew Bowd
Registration: Dornach, Landkr. Muenchen; Registerger. Muenchen, HRB Nr. 43632

