Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758112Ab1ANSSO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Jan 2011 13:18:14 -0500
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:60804 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757625Ab1ANSSE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Jan 2011 13:18:04 -0500
Date: Fri, 14 Jan 2011 18:17:46 +0000
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Nicolas Ferre <nicolas.ferre@atmel.com>
Cc: "'linux-arm-kernel@lists.infradead.org'" 
	<linux-arm-kernel@lists.infradead.org>,
        Linux Kernel list <linux-kernel@vger.kernel.org>,
        Igor Plyatov <plyatov@gmail.com>, Andrew Victor <linux@maxim.org.za>,
        Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>,
        Sergio Tanzilli <tanzilli@acmesystems.it>
Subject: Re: [GIT PULL] AT91: patches for v2.6.38-rc1
Message-ID: <20110114181746.GM15996@n2100.arm.linux.org.uk>
References: <4D308F30.6070503@atmel.com> <20110114180455.GL15996@n2100.arm.linux.org.uk> <4D309278.5010603@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4D309278.5010603@atmel.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 14, 2011 at 07:14:16PM +0100, Nicolas Ferre wrote:
> Le 14/01/2011 19:04, Russell King - ARM Linux :
> > On Fri, Jan 14, 2011 at 07:00:16PM +0100, Nicolas Ferre wrote:
> >> Hi Russell,
> >>
> >> Can you please pull those little changes for AT91? They add two 
> >> new boards already discussed on the mailing list and a little 
> >> cleanup patch:
> > 
> > Has this already been in linux-next?
> 
> I must admit that... no.
> 
> > We should only be merging new code during a merge window which has
> > already had visibility in linux-next, with the exception of bug fixes
> > and regression fixes.
> 
> I understand your point but those are only *board* files that are lying
> around for one or two months.
> I was really wishing to see them included in mainline during merge
> window as they are not core ARM nor AT91 files...

Okay for this time, but please ensure that stuff like this is in
linux-next before the merge window next time so that it can have
some exposure.
