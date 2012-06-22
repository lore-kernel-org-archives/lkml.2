Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761197Ab2FVFjj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Jun 2012 01:39:39 -0400
Received: from gate.crashing.org ([63.228.1.57]:57640 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757345Ab2FVFji (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Jun 2012 01:39:38 -0400
Message-ID: <1340343557.16104.35.camel@pasglop>
Subject: Re: [PATCH 1/1] of: reform prom_update_property function
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Dong Aisheng <dongas86@gmail.com>
Cc: Dong Aisheng <aisheng.dong@freescale.com>,
        Rob Herring <robherring2@gmail.com>,
        Dong Aisheng-B29396 <B29396@freescale.com>,
        "devicetree-discuss@lists.ozlabs.org" 
	<devicetree-discuss@lists.ozlabs.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Kumar Gala <galak@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>
Date: Fri, 22 Jun 2012 15:39:17 +1000
In-Reply-To: <CAA+hA=RoxfXWOQbZ2i=6w8GJShbpdi4EzkQRghSi2DL5F8pAng@mail.gmail.com>
References: <1340171647-2815-1-git-send-email-b29396@freescale.com>
	 <4FE1CB2C.5040208@gmail.com> <1340237796.28143.207.camel@pasglop>
	 <20120621093702.GE21231@shlinux2.ap.freescale.net>
	 <1340323284.16104.4.camel@pasglop>
	 <CAA+hA=RoxfXWOQbZ2i=6w8GJShbpdi4EzkQRghSi2DL5F8pAng@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2012-06-22 at 13:25 +0800, Dong Aisheng wrote:
> Which seems the same behavior as the new prop_update_property api.
> The only different is if no name, return -EINVAL;
> Am i wrong?

No, you are right. Sorry for the noise :-)

Cheers,
Ben.


