Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754674Ab1AUMt2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Jan 2011 07:49:28 -0500
Received: from mail.southpole.se ([193.12.106.18]:50369 "EHLO
	mail.southpole.se" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753834Ab1AUMt1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Jan 2011 07:49:27 -0500
X-Greylist: delayed 1312 seconds by postgrey-1.27 at vger.kernel.org; Fri, 21 Jan 2011 07:49:27 EST
Subject: Re: [PATCH v2] spi: add OpenCores tiny SPI driver
From: Jonas Bonn <jonas@southpole.se>
To: Thomas Chou <thomas@wytron.com.tw>
Cc: Grant Likely <grant.likely@secretlab.ca>, nios2-dev@sopc.et.ntust.edu.tw,
        David Brownell <dbrownell@users.sourceforge.net>,
        Mike Frysinger <vapier@gentoo.org>,
        devicetree-discuss@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        spi-devel-general@lists.sourceforge.net
In-Reply-To: <4D38AAEB.7020308@wytron.com.tw>
References: <1294800109-31603-1-git-send-email-thomas@wytron.com.tw>
	 <1295249542-26743-1-git-send-email-thomas@wytron.com.tw>
	 <20110120165430.GA24445@angua.secretlab.ca>
	 <4D38AAEB.7020308@wytron.com.tw>
Content-Type: text/plain; charset="UTF-8"
Organization: South Pole AB
Date: Fri, 21 Jan 2011 13:27:29 +0100
Message-ID: <1295612849.23825.26.camel@needafix>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

> 
> >> +#ifdef CONFIG_OF
> >> +static struct of_device_id oc_tiny_spi_match[] = {
> >> +	{
> >> +		.compatible = "opencores,oc_tiny_spi",
> >
> > If this is a soft core, then there should be a version number of some
> > sort on the compatible value.  Also, please use dash '-' instead of
> > underscore '_' in compatible values.  Also, for all of these new
> > bindings, they need to be documented.  Please add documentation to
> > Documentation/powerpc/dts-bindings (yes, I know, this is not
> > for powerpc, but that is the established directory.  I'll move it to a
> > better location soon).
> >

It would be nice to use the same name for the OpenCores project and the
device tree identifier, and since "opencores" is already in the name,
the "oc_" bit is superfluous anyway.  I'd suggest "opencores,tiny-spi"
in order to match your OpenCores project name.

Versioning of OpenCores cores is not sorted yet.  In order to avoid
clashing with the versioning/naming scheme that's decided on, please
just use a neutral version number for now (especially as your core is so
new).  e.g. "opencores,tiny-spi-0"

/Jonas

