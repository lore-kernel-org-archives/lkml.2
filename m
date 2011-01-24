Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753337Ab1AXPuK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Jan 2011 10:50:10 -0500
Received: from mail-pz0-f46.google.com ([209.85.210.46]:42811 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753263Ab1AXPuH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Jan 2011 10:50:07 -0500
Date: Mon, 24 Jan 2011 08:50:02 -0700
From: Grant Likely <grant.likely@secretlab.ca>
To: Thomas Chou <thomas@wytron.com.tw>
Cc: Jonas Bonn <jonas@southpole.se>, nios2-dev@sopc.et.ntust.edu.tw,
        David Brownell <dbrownell@users.sourceforge.net>,
        Mike Frysinger <vapier@gentoo.org>,
        devicetree-discuss@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        spi-devel-general@lists.sourceforge.net
Subject: Re: [PATCH v2] spi: add OpenCores tiny SPI driver
Message-ID: <20110124155002.GA16370@angua.secretlab.ca>
References: <1294800109-31603-1-git-send-email-thomas@wytron.com.tw>
 <1295249542-26743-1-git-send-email-thomas@wytron.com.tw>
 <20110120165430.GA24445@angua.secretlab.ca>
 <4D38AAEB.7020308@wytron.com.tw>
 <1295612849.23825.26.camel@needafix>
 <4D3CD38D.4080808@wytron.com.tw>
 <1295866794.23825.100.camel@needafix>
 <4D3D91D1.8000701@wytron.com.tw>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4D3D91D1.8000701@wytron.com.tw>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 24, 2011 at 10:50:57PM +0800, Thomas Chou wrote:
> Hi Jonas,
> 
> On 01/24/2011 06:59 PM, Jonas Bonn wrote:
> >We've discussed this a bit internally now and decided that the best way
> >to version OpenCores cores is to use the SVN commit ID of the rtl/
> >directory in the project's repository.  So, for your tiny-spi project,
> >the last SVN commit to update the rtl/ directory was commit number 2;
> >hence, I'd recommend you use the following device tree identifier:
> >
> >opencores,tiny-spi-rtlsvn2
> >
> >That's:  opencores,<project>-rtl<VCS><commit ID>
> >
> >As projects are currently in SVN, VCS=svn.
> >
> >Linux drivers for other OpenCores cores will be updated accordingly.
> 
> I will follow your suggestion exactly. Thank you very much.

Make sure you also document the binding in Documentation/powerpc/dts-bindings

g.

