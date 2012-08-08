Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758136Ab2HHMnS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Aug 2012 08:43:18 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:50851 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758014Ab2HHMnQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Aug 2012 08:43:16 -0400
Date: Wed, 8 Aug 2012 13:43:13 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Samuel Ortiz <sameo@linux.intel.com>, linux-kernel@vger.kernel.org,
        Haojian Zhuang <haojian.zhuang@gmail.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Russell King <rmk@arm.linux.org.uk>, "v3.4+" <stable@vger.kernel.org>
Subject: Re: [PATCH 1/7] mfd: max8925: Move _IO resources out of
 ioport_ioresource
Message-ID: <20120808124313.GP16861@opensource.wolfsonmicro.com>
References: <1344364969-32489-1-git-send-email-broonie@opensource.wolfsonmicro.com>
 <201208071946.52211.arnd@arndb.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201208071946.52211.arnd@arndb.de>
X-Cookie: You will be married within a year.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 07, 2012 at 07:46:52PM +0000, Arnd Bergmann wrote:

> Thanks a lot for following through with this series! I would have
> preferred to have the second step in stable as Russell suggested,
> but since you did all the work, I'm not going to complain about it ;-)

Yeah, it'd be nicer to do it but given that the second step is adding a
new, non-bitmask resource type to a set of resource types that have
previously been all bitmasks I know I'd not get taken seriously
suggesting it as a fix to a system integrator without a big argument
about it and general unhappiness, most people doing stable releases I've
worked with would have a similar response.  It's not that it's unsafe,
it's that it sets off alarm bells and requires more due dilligence.
