Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756081Ab1IGSEu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Sep 2011 14:04:50 -0400
Received: from d1.icnet.pl ([212.160.220.21]:55935 "EHLO d1.icnet.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756047Ab1IGSEs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Sep 2011 14:04:48 -0400
From: Janusz Krzysztofik <jkrzyszt@tis.icnet.pl>
Organization: Tele-Info-System, Poznan, PL
To: "Russell King - ARM Linux" <linux@arm.linux.org.uk>
Subject: Re: [PATCH 3.1-rc1] ARM: entry: fix wrong parameter used in do_thumb_abort
Date: Wed, 7 Sep 2011 19:58:47 +0200
User-Agent: KMail/1.13.7 (Linux/2.6.38-gentoo-r6; KDE/4.6.3; i686; ; )
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
References: <201108241307.21056.jkrzyszt@tis.icnet.pl> <201109071310.09266.jkrzyszt@tis.icnet.pl> <20110907114740.GS6619@n2100.arm.linux.org.uk>
In-Reply-To: <20110907114740.GS6619@n2100.arm.linux.org.uk>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201109071958.47945.jkrzyszt@tis.icnet.pl>
X-SA-Exim-Scanned: No (on d1.icnet); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 7 Sep 2011 at 13:47:40 Russell King - ARM Linux wrote:
> On Wed, Sep 07, 2011 at 01:10:08PM +0200, Janusz Krzysztofik wrote:
> > Any special requirements as to the process of submitting bug fixes
> > against arch/arm common bits?
> 
> It needs to go into the patch system for merging so that it doesn't
> get buried and forgotten - as already demonstrated.

Still not sure: am I suppposed to do something for the patch to go to 
the patch system? Or do you take care of this?

Thanks,
Janusz
