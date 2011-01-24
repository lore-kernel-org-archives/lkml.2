Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752647Ab1AXK76 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Jan 2011 05:59:58 -0500
Received: from mail.southpole.se ([193.12.106.18]:39814 "EHLO
	mail.southpole.se" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751357Ab1AXK75 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Jan 2011 05:59:57 -0500
Subject: Re: [PATCH v2] spi: add OpenCores tiny SPI driver
From: Jonas Bonn <jonas@southpole.se>
To: Thomas Chou <thomas@wytron.com.tw>
Cc: Grant Likely <grant.likely@secretlab.ca>, nios2-dev@sopc.et.ntust.edu.tw,
        David Brownell <dbrownell@users.sourceforge.net>,
        Mike Frysinger <vapier@gentoo.org>,
        devicetree-discuss@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        spi-devel-general@lists.sourceforge.net
In-Reply-To: <4D3CD38D.4080808@wytron.com.tw>
References: <1294800109-31603-1-git-send-email-thomas@wytron.com.tw>
	 <1295249542-26743-1-git-send-email-thomas@wytron.com.tw>
	 <20110120165430.GA24445@angua.secretlab.ca>
	 <4D38AAEB.7020308@wytron.com.tw> <1295612849.23825.26.camel@needafix>
	 <4D3CD38D.4080808@wytron.com.tw>
Content-Type: text/plain; charset="UTF-8"
Organization: South Pole AB
Date: Mon, 24 Jan 2011 11:59:54 +0100
Message-ID: <1295866794.23825.100.camel@needafix>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Thomas,

> > Versioning of OpenCores cores is not sorted yet.  In order to avoid
> > clashing with the versioning/naming scheme that's decided on, please
> > just use a neutral version number for now (especially as your core is so
> > new).  e.g. "opencores,tiny-spi-0"
> >
> 
> Thanks. I will update it to "opencores,tiny-spi-1.0".
> 

We've discussed this a bit internally now and decided that the best way
to version OpenCores cores is to use the SVN commit ID of the rtl/
directory in the project's repository.  So, for your tiny-spi project,
the last SVN commit to update the rtl/ directory was commit number 2;
hence, I'd recommend you use the following device tree identifier:

opencores,tiny-spi-rtlsvn2

That's:  opencores,<project>-rtl<VCS><commit ID>

As projects are currently in SVN, VCS=svn.

Linux drivers for other OpenCores cores will be updated accordingly.

/Jonas

