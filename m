Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752423Ab2HAMOh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Aug 2012 08:14:37 -0400
Received: from [213.199.154.144] ([213.199.154.144]:47694 "EHLO
	db3outboundpool.messaging.microsoft.com" rhost-flags-FAIL-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1751578Ab2HAMOf convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Aug 2012 08:14:35 -0400
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: -7
X-BigFish: VS-7(zz98dI9371I542M1432Izz1202hzz8275dhz2dh2a8h668h839h8e2h8e3h944hd25hf0ah107ahbe9i)
From: Singh Sandeep-B37400 <B37400@freescale.com>
To: Greg KH <greg@kroah.com>
CC: Francois Romieu <romieu@fr.zoreil.com>,
        "devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>,
        "linuxppc-dev@lists.ozlabs.org" <linuxppc-dev@lists.ozlabs.org>,
        "galak@kernel.crashing.org" <galak@kernel.crashing.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [2/3][PATCH][v2] TDM Framework
Thread-Topic: [2/3][PATCH][v2] TDM Framework
Thread-Index: AQHNbADsHRsnZfKnik2om4CTBsszqJc9k/oAgAQA/cCAAMAWAIACjwiQ
Date: Wed, 1 Aug 2012 12:13:19 +0000
Message-ID: <3F1D9DCAAB49B94D88DBE05911FA4E6E515F98@039-SN1MPN1-001.039d.mgd.msft.net>
References: <1343397940-12975-1-git-send-email-sandeep@freescale.com>
 <20120727152542.GB1613@electric-eye.fr.zoreil.com>
 <3F1D9DCAAB49B94D88DBE05911FA4E6E511121@039-SN1MPN1-006.039d.mgd.msft.net>
 <20120730160146.GB28703@kroah.com>
In-Reply-To: <20120730160146.GB28703@kroah.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.232.134.45]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org




> -----Original Message-----
> From: Greg KH [mailto:greg@kroah.com]
> Sent: Monday, July 30, 2012 9:32 PM
> To: Singh Sandeep-B37400
> Cc: Francois Romieu; devel@driverdev.osuosl.org; linuxppc-
> dev@lists.ozlabs.org; galak@kernel.crashing.org; linux-arm-
> kernel@lists.infradead.org; linux-kernel@vger.kernel.org
> Subject: Re: [2/3][PATCH][v2] TDM Framework
> 
> On Mon, Jul 30, 2012 at 09:50:57AM +0000, Singh Sandeep-B37400 wrote:
> > 1. You should send some kernel mode TDM clients. Without those the
> framework
> >    is pretty useless.
> > [Sandeep] We do have a test client but not good enough to be pushed in
> > open source, should we add it to documentation??
> 
> Then how do you know if the framework is "correct" and good enough for
> real clients?  We don't add frameworks, or apis, to the kernel without
> users, so you will have to come up with some users before we can accept
> it.
We can only say that this framework is available in FSL BSPs and being used by VoIP companies.
But running a complete voice stack itself is beyond the scope of Freescale.
So vendors integrate their solutions with FSL solution.
To test the framework we have a small application in our BSP (this is a very basic test client) which tests the TDM driver and the SLIC interface from voice  transfer perspective.
We can get this added in the Linux codebase in some test directory. What could be a good place for this?

Regards
Sandeep


