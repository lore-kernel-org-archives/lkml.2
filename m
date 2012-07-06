Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932188Ab2GFJVS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jul 2012 05:21:18 -0400
Received: from ch1ehsobe002.messaging.microsoft.com ([216.32.181.182]:6311
	"EHLO ch1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754577Ab2GFJVN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jul 2012 05:21:13 -0400
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: -1
X-BigFish: VS-1(zzbb2dI98dI9371I1432Izz1202h1082kzz8275bh8275dhz2dh2a8h668h839h944hd25hf0ah107ah)
Date: Fri, 6 Jul 2012 17:13:36 +0800
From: Dong Aisheng <b29396@freescale.com>
To: Rob Herring <robherring2@gmail.com>
CC: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devicetree-discuss@lists.ozlabs.org" 
	<devicetree-discuss@lists.ozlabs.org>,
        "paulus@samba.org" <paulus@samba.org>,
        "linuxppc-dev@lists.ozlabs.org" <linuxppc-dev@lists.ozlabs.org>
Subject: Re: [PATCH v2 1/1] of: reform prom_update_property function
Message-ID: <20120706091335.GB28264@shlinux2.ap.freescale.net>
References: <1340605714-25206-1-git-send-email-b29396@freescale.com>
 <4FE8F6DA.8070109@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <4FE8F6DA.8070109@gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 26, 2012 at 07:40:10AM +0800, Rob Herring wrote:
> On 06/25/2012 01:28 AM, Dong Aisheng wrote:
> > From: Dong Aisheng <dong.aisheng@linaro.org>
> > 
> > prom_update_property() currently fails if the property doesn't
> > actually exist yet which isn't what we want. Change to add-or-update
> > instead of update-only, then we can remove a lot duplicated lines.
> > 
> > Suggested-by: Grant Likely <grant.likely@secretlab.ca>
> > Signed-off-by: Dong Aisheng <dong.aisheng@linaro.org>
> 
> Acked-by: Rob Herring <rob.herring@calxeda.com>
> 
> Ben, you can merge this via powerpc.
> 
> Rob
> 
Ping...

Regards
Dong Aisheng

