Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752971Ab2G3JvE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jul 2012 05:51:04 -0400
Received: from co1ehsobe002.messaging.microsoft.com ([216.32.180.185]:42754
	"EHLO co1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752329Ab2G3JvB convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jul 2012 05:51:01 -0400
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: -5
X-BigFish: VS-5(zz542M1432Izz1202hzz8275ch8275bh8275dhz2dh2a8h668h839h8e2h8e3h944hd25hf0ah107ahbe9i)
From: Singh Sandeep-B37400 <B37400@freescale.com>
To: Francois Romieu <romieu@fr.zoreil.com>
CC: "linuxppc-dev@lists.ozlabs.org" <linuxppc-dev@lists.ozlabs.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "galak@kernel.crashing.org" <galak@kernel.crashing.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>
Subject: RE: [2/3][PATCH][v2] TDM Framework
Thread-Topic: [2/3][PATCH][v2] TDM Framework
Thread-Index: AQHNbADsHRsnZfKnik2om4CTBsszqJc9k/oAgAQA/cA=
Date: Mon, 30 Jul 2012 09:50:57 +0000
Message-ID: <3F1D9DCAAB49B94D88DBE05911FA4E6E511121@039-SN1MPN1-006.039d.mgd.msft.net>
References: <1343397940-12975-1-git-send-email-sandeep@freescale.com>
 <20120727152542.GB1613@electric-eye.fr.zoreil.com>
In-Reply-To: <20120727152542.GB1613@electric-eye.fr.zoreil.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.232.14.97]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thanks for your comments. Please find replies inline.

Regards,
Sandeep

-----Original Message-----
From: Francois Romieu [mailto:romieu@fr.zoreil.com] 
Sent: 27 July 2012 20:56
To: Singh Sandeep-B37400
Cc: linuxppc-dev@lists.ozlabs.org; linux-arm-kernel@lists.infradead.org; galak@kernel.crashing.org; linux-kernel@vger.kernel.org; devel@driverdev.osuosl.org
Subject: Re: [2/3][PATCH][v2] TDM Framework

sandeep@freescale.com <sandeep@freescale.com> :
[...]
> The main functions of this Framework are:
>  - provides interface to TDM clients to access TDM functionalities.
>  - provides standard interface for TDM drivers to hook with the framework.
>  - handles various data handling stuff and buffer management.
> 
> In future this Framework will be extended to provide Interface for Line control devices also. For example SLIC, E1/T1 Framers etc.
> 
> Presently the framework supports only Single Port channelised mode.
> Also the configurability options are limited which will be extended later on.
> Only kernel mode TDM clients are supported currently. Support for User mode clients will be added later.

1. You should send some kernel mode TDM clients. Without those the framework
   is pretty useless.
[Sandeep] We do have a test client but not good enough to be pushed in open source, should we add it to documentation?? 

2. It would probably make sense to Cc: netdev and serial. There may be
   some kernel client network integration from the start.
[Sandeep] Ok. 

3. Where is the userspace configuration interface ?
[Sandeep] TDM framework right now supports only kernel mode clients. It has been tested with the client module that I mentioned above. Both the framework and test client are a part of Freescale BSP.

[...]
> Based on: git://git.am.freescale.net/gitolite/mirrors/galak-powerpc.git
[Sandeep] Please try below mentioned link. The above one is Freescale's internal mirror of:
git://git.kernel.org/pub/scm/linux/kernel/git/galak/powerpc.git 

$ git clone git://git.am.freescale.net/gitolite/mirrors/galak-powerpc.git
Cloning into 'galak-powerpc'...
fatal: Unable to look up git.am.freescale.net (port 9418) (No address associated with hostname)

-- 
Ueimor


