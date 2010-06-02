Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757758Ab0FBKHW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jun 2010 06:07:22 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:41191 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751694Ab0FBKHU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jun 2010 06:07:20 -0400
Date: Wed, 2 Jun 2010 11:07:18 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Linus WALLEIJ <linus.walleij@stericsson.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Bengt JONSSON <bengt.g.jonsson@stericsson.com>,
       Sundar R IYER <sundar.iyer@stericsson.com>
Subject: Re: RFC: Regulator Framework Voltage Setting
Message-ID: <20100602100718.GB13983@rakim.wolfsonmicro.main>
References: <CEE6BB42CAD6E947908279175AF8470A025A8A54F4@EXDCVYMBSTM006.EQ1STM.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CEE6BB42CAD6E947908279175AF8470A025A8A54F4@EXDCVYMBSTM006.EQ1STM.local>
X-Cookie: //GO.SYSIN DD *, DOODAH, DOODAH
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 02, 2010 at 11:18:00AM +0200, Linus WALLEIJ wrote:

> Our questions:
> - Is this the correct interpretation of the current functionality?
> - Is the proposed behaviour what you would expect?
> - Any other problems to consider?

The current expectation is that a consumer that really needs a voltage
setting will have exclusive use of the regulator and won't share it with
other consumers.  There was some support for combining constraints from
multiple consumers originally but it got removed due to requests from
David Brownell (there's not actually much demand for this feature
anyway, finding devices which support but do not required DVS is
actually quite hard and generally the power requirments for shared rails
get fixed at hardware build tiem).
