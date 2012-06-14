Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755270Ab2FNISo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jun 2012 04:18:44 -0400
Received: from mail2.gnudd.com ([213.203.150.91]:51687 "EHLO mail.gnudd.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754595Ab2FNISl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jun 2012 04:18:41 -0400
Date: Thu, 14 Jun 2012 10:17:58 +0200
From: Alessandro Rubini <rubini@gnudd.com>
To: arnd@arndb.de
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        giancarlo.asnaghi@st.com, linux@arm.linux.org.uk,
        linus.walleij@stericsson.com, srinidhi.kasagar@stericsson.com,
        w.sang@pengutronix.de, khali@linux-fr.org, linux-i2c@vger.kernel.org,
        STEricsson_nomadik_linux@list.st.com, lee.jones@linaro.org,
        alan@linux.intel.com
Subject: Re: [PATCH V3 2/3] i2c-nomadik: turn the platform driver to an
 amba driver
Message-ID: <20120614081758.GA19648@mail.gnudd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Organization: GnuDD, Device Drivers, Embedded Systems, Courses
In-Reply-To: <201206140804.39083.arnd@arndb.de>
References: <201206140804.39083.arnd@arndb.de>
  <cover.1339447570.git.rubini@gnudd.com>
 <4a198618063924b68182279ffd56c335d621f542.1339447570.git.rubini@gnudd.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> You change only one half of ux500 here: the part where the device
> gets defined statically, but not not the definition in the
> device-tree.

Yes, I'm aware. That's why I added Lee Jones as Cc:, on Linusw's
suggestion.  Lee told me to go ahead and he'll fix the DT stuff.
Lee?

thanks
/alessandro
