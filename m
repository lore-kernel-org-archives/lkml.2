Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756776Ab0GMO5b (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jul 2010 10:57:31 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:47966 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752510Ab0GMO53 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jul 2010 10:57:29 -0400
Date: Tue, 13 Jul 2010 15:57:28 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Sundar R IYER <sundar.iyer@stericsson.com>
Cc: "lrg@slimlogic.co.uk" <lrg@slimlogic.co.uk>,
        "sameo@linux.intel.com" <sameo@linux.intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        STEricsson_nomadik_linux <STEricsson_nomadik_linux@list.st.com>,
        Linus WALLEIJ <linus.walleij@stericsson.com>,
        Bengt JONSSON <bengt.g.jonsson@stericsson.com>
Subject: Re: [PATCH v2 1/2] regulator: add support for regulators on the
 ab8500 MFD
Message-ID: <20100713145727.GB24626@rakim.wolfsonmicro.main>
References: <1279030173-3086-1-git-send-email-sundar.iyer@stericsson.com>
 <20100713141709.GA24260@rakim.wolfsonmicro.main>
 <33A307AF30D7BF4F811B1568FE7A9B1810E7E880@EXDCVYMBSTM006.EQ1STM.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <33A307AF30D7BF4F811B1568FE7A9B1810E7E880@EXDCVYMBSTM006.EQ1STM.local>
X-Cookie: Goodbye, cool world.
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 13, 2010 at 04:34:56PM +0200, Sundar R IYER wrote:

> >> + * @mask: mask to enable/disable regulator
> >> + * @enable: bits to enable the regulator in normal(high power) mode
> >Have you addressed my comments here?
> Sorry that I couldn't inline my replies into the patch itself :(. I changed the comments for the variable
> from the previous patch set. But I agree I messed up!

> Yes. The mask here is different for the fact that we have two enable bits; enable LP(low power)
> mode and enable HP(high power). We enable only the HP modes and hence the different mask
> for enable/disable as well as for the enable.

OK.
