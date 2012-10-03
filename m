Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755579Ab2JCR7q (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Oct 2012 13:59:46 -0400
Received: from smtprelay-b21.telenor.se ([195.54.99.212]:56978 "EHLO
	smtprelay-b21.telenor.se" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751566Ab2JCR7o (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Oct 2012 13:59:44 -0400
X-SENDER-IP: [85.230.29.114]
X-LISTENER: [smtp.bredband.net]
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AgVJAJN8bFBV5h1yPGdsb2JhbABFhSS5URkBAQEBHxkNJ4IgAQEEATocIwULCANGFCUKGogSCge3RRSLD4VaYAOVaIEWhFyNKQ
X-IronPort-AV: E=Sophos;i="4.80,529,1344204000"; 
   d="scan'208";a="423023535"
From: "Henrik Rydberg" <rydberg@euromail.se>
Date: Wed, 3 Oct 2012 20:01:21 +0200
To: Alexandra Chin <alexandra.chin@tw.synaptics.com>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Linux Input <linux-input@vger.kernel.org>,
        Linus Walleij <linus.walleij@stericsson.com>,
        Naveen Kumar Gaddipati <naveen.gaddipati@stericsson.com>,
        Mahesh Srinivasan <msrinivasan@synaptics.com>,
        Alex Chang <alex.chang@tw.synaptics.com>,
        Scott Lin <scott.lin@tw.synaptics.com>,
        Christopher Heiny <Cheiny@synaptics.com>
Subject: Re: [PATCH] Input: Add new driver into Input Subsystem for Synaptics
 DS4 touchscreen I2C devices
Message-ID: <20121003180121.GA4198@polaris.bitmath.org>
References: <CC51EC7B5B7F984AA566DC102237848896F590C0@hkdcw-mail1.synaptics-inc.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CC51EC7B5B7F984AA566DC102237848896F590C0@hkdcw-mail1.synaptics-inc.local>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Alexandra,

> Hi Henrik/Dmitry,
> 
> We are working on a product specific driver for Synaptics DS4 I2C touchscreen
> devices. It was submitted on Sept. 16, 2012, but has not been reviewed.
> (http://lkml.org/lkml/2012/9/16/24). 
> We found several warnings after running script/checkpatch.pl, therefore 
> an updated patch is attached.
> 
> As Chris says in https://lkml.org/lkml/2012/9/19/505, this driver will enable
> us to support all our customers effectively and provide our customers with 
> the best flexibility possible.
> Please help review attached patch, and we really appreciate your feedback :-)

It seems this driver is already present in staging. Comments and
formatting have been improved in the staging version, but that aside,
the two versions look very similar.  Why don't you submit fixes to
that driver instead?

On a general note, both versions of the driver use MT-A. Please
convert to MT-B, using the in-kernel tracking if necessary.

Thanks.
Henrik
