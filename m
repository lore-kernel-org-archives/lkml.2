Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752246Ab1GHJ3x (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jul 2011 05:29:53 -0400
Received: from am1ehsobe001.messaging.microsoft.com ([213.199.154.204]:33683
	"EHLO AM1EHSOBE001.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751319Ab1GHJ3t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jul 2011 05:29:49 -0400
X-SpamScore: -9
X-BigFish: VS-9(zz1432N98dKzz1202hzz8275dhz2dh2a8h668h839h944h61h)
X-Spam-TCS-SCL: 0:0
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPVD:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
Date: Fri, 8 Jul 2011 17:36:06 +0800
From: Shawn Guo <shawn.guo@freescale.com>
To: Shawn Guo <shawn.guo@linaro.org>
CC: <linux-arm-kernel@lists.infradead.org>, <patches@linaro.org>,
        <netdev@vger.kernel.org>, <devicetree-discuss@lists.ozlabs.org>,
        <linux-kernel@vger.kernel.org>, <linux-serial@vger.kernel.org>
Subject: Re: [PATCH v2 1/5] dt: add of_alias_scan and of_alias_get_id
Message-ID: <20110708093605.GE12722@S2100-06.ap.freescale.net>
References: <1308938676-31121-1-git-send-email-shawn.guo@linaro.org>
 <1308938676-31121-2-git-send-email-shawn.guo@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <1308938676-31121-2-git-send-email-shawn.guo@linaro.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Grant,

I saw neither your comments nor ack on this patch.  Where does it go?

Regards,
Shawn

On Sat, Jun 25, 2011 at 02:04:32AM +0800, Shawn Guo wrote:
> The patch adds function of_alias_scan to populate a global lookup
> table with the properties of 'aliases' node and function
> of_alias_get_id for drivers to find alias id from the lookup table.
> 
> Signed-off-by: Shawn Guo <shawn.guo@linaro.org>
> Cc: Grant Likely <grant.likely@secretlab.ca>
> ---

