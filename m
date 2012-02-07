Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756293Ab2BGMbr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Feb 2012 07:31:47 -0500
Received: from ch1ehsobe003.messaging.microsoft.com ([216.32.181.183]:59924
	"EHLO ch1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756259Ab2BGMbp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Feb 2012 07:31:45 -0500
X-SpamScore: -12
X-BigFish: VPS-12(zz936eK1432N98dKzz1202hzzz2dh2a8h668h839h93fh)
X-Forefront-Antispam-Report: CIP:59.163.77.45;KIP:(null);UIP:(null);IPV:NLI;H:Outbound.kpitcummins.com;RD:59.163.77.45.static.vsnl.net.in;EFVD:NLI
Subject: Re: [PATCH 06/07] RTC: RTC driver for DA9052/53 PMIC v1
From: Ashish Jangam <ashish.jangam@kpitcummins.com>
To: <akpm@linux-foundation.org>
CC: <linux-kernel@vger.kernel.org>, <sameo@linux.intel.com>,
        <p_gortmaker@yahoo.com>, <dchen@diasemi.com>
In-Reply-To: <C3AE124F08223B42BC95AEB82F0F6CED1FDDA892@KCHJEXMB02.kpit.com>
References: <C3AE124F08223B42BC95AEB82F0F6CED1FDDA892@KCHJEXMB02.kpit.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 7 Feb 2012 17:55:02 +0530
Message-ID: <1328617502.30549.91.camel@dhruva>
MIME-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.10.38.47]
X-OriginatorOrg: kpitcummins.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2012-02-07 at 17:51 +0530, Ashish Jangam wrote:
> I assume that this patch is mergeable without any of the other six
> patches in this series.  It compiles OK...
yes
> 
> > +{
> > +	int ret;
> > +	uint8_t v[5] = {0, 0, 0, 0, 0};
> 
> These initalised local arrays are expensive.  The below patch reduces
> the module's text size by over 100 bytes.
> 
> The arrays whcih are passed to da9052_group_write() surely didn't need
> initalisation, and I trust that's also the case with the arrays which
> are passed to da9052_group_read()?
Correct, they can be passed without initialisation.


