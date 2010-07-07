Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753721Ab0GGBPf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Jul 2010 21:15:35 -0400
Received: from LUNGE.MIT.EDU ([18.54.1.69]:33513 "EHLO lunge.queued.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751311Ab0GGBPd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Jul 2010 21:15:33 -0400
Date: Tue, 6 Jul 2010 18:15:09 -0700
From: Andres Salomon <dilinger@queued.net>
To: Grant Likely <grant.likely@secretlab.ca>
Cc: devicetree-discuss@lists.ozlabs.org, sparclinux@vger.kernel.org,
       x86@kernel.org, tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com,
       cjb@laptop.org, Mitch Bradley <wmb@laptop.org>, pgf@laptop.org,
       linux-kernel@vger.kernel.org, davem@davemloft.net
Subject: Re: [PATCH 2/4] sparc: break out some prom device-tree building
 code  out into drivers/of
Message-ID: <20100706181509.51b37ebf@Nokia-N900-42-11>
In-Reply-To: <AANLkTilt0cdnCt5EI3adWNAxpNR4jmLL87sMpGVXP03Y@mail.gmail.com>
References: <20100628215407.2017bf2f@debian>
	<20100628220037.5744c207@debian>
	<AANLkTikDdAuDOxBVgV_QDY-YZOOZCyl1O5aYzDXCjW10@mail.gmail.com>
	<20100706145446.5e8540aa@Nokia-N900-42-11>
	<AANLkTilt0cdnCt5EI3adWNAxpNR4jmLL87sMpGVXP03Y@mail.gmail.com>
X-Mailer: Claws Mail 3.7.3 (GTK+ 2.14.7; arm-unknown-linux-gnueabi)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 6 Jul 2010 16:06:54 -0600
Grant Likely <grant.likely@secretlab.ca> wrote:
[...] 
> Okay, so it is only the userspace interface that you're interested in,
> correct?  You have no needs/plans (as of yet) to register devices out
> of the device tree?
> 

Correct.

