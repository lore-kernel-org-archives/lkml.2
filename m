Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752900Ab2BAXVU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Feb 2012 18:21:20 -0500
Received: from mail-pz0-f46.google.com ([209.85.210.46]:64064 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752344Ab2BAXVR convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Feb 2012 18:21:17 -0500
MIME-Version: 1.0
In-Reply-To: <CACxGe6uafURnPOGRNpKKXXMM06JHFoqDVqHojQdv_aeCAd_Sfg@mail.gmail.com>
References: <1328121082-21802-1-git-send-email-grant.likely@secretlab.ca>
 <1328130989.28487.83.camel@pasglop> <CACxGe6uafURnPOGRNpKKXXMM06JHFoqDVqHojQdv_aeCAd_Sfg@mail.gmail.com>
From: Grant Likely <grant.likely@secretlab.ca>
Date: Wed, 1 Feb 2012 16:20:57 -0700
X-Google-Sender-Auth: cxHAXWWwFJwufo2v9Su-7aMPR28
Message-ID: <CACxGe6vU=jL7tqXQKdzqksEmDNgvN5U+HdypgC3bUcQaqxSuRQ@mail.gmail.com>
Subject: Re: [PATCH] drivercore: Output common devicetree information in uevent
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Tobias Klauser <tklauser@distanz.ch>, Frederic Lambert <frdrc66@gmail.com>,
        Rob Herring <rob.herring@calxeda.com>,
        Mark Brown <broonie@sirena.org.uk>,
        "David S. Miller" <davem@davemloft.net>,
        Greg Kroah-Hartman <greg@kroah.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        devicetree-discuss <devicetree-discuss@lists.ozlabs.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 1, 2012 at 2:29 PM, Grant Likely <grant.likely@secretlab.ca> wrote:
> On Wed, Feb 1, 2012 at 2:16 PM, Benjamin Herrenschmidt
> <benh@kernel.crashing.org> wrote:
>> On Wed, 2012-02-01 at 11:31 -0700, Grant Likely wrote:
>>> The original function also creates a MODALIAS property for the
>>> compatible
>>> list, but that code has not been generalized into the common case
>>> because
>>> it has the potential to break module loading on a lot of bus types.
>>> Bus
>>> types are still responsible for their own MODALIAS properties.
>>>
>>> Boot tested on ARM and compile tested on PowerPC and SPARC.
>>>
>>>
>> We also want to generalize adding the devspec property that we have on
>> PCI to all devices no ?
>
> The pci_show_devspec() function?  Yeah, that can be generalized, but
> haven't researched where the best place to hook it in should be.

Is there any point in generalizing that attribute though when the data
is in uevent?

g.
