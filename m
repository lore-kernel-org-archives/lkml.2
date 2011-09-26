Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752168Ab1IZOnN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Sep 2011 10:43:13 -0400
Received: from smtprelay-b22.telenor.se ([195.54.99.213]:43136 "EHLO
	smtprelay-b22.telenor.se" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751195Ab1IZOnM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Sep 2011 10:43:12 -0400
X-SENDER-IP: [85.230.168.63]
X-LISTENER: [smtp.bredband.net]
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AtFXAD2OgE5V5qg/PGdsb2JhbABBiSmeZwsBAQEBNzOBUwEBBTocIxAIAw4KLhQlChqIDblgDoYdYASZAowF
X-IronPort-AV: E=Sophos;i="4.68,444,1312149600"; 
   d="scan'208";a="119844496"
From: "Henrik Rydberg" <rydberg@euromail.se>
Date: Mon, 26 Sep 2011 16:46:35 +0200
To: Jiri Kosina <jkosina@suse.cz>
Cc: Benjamin Tissoires <benjamin.tissoires@gmail.com>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Benjamin Tissoires <benjamin.tissoires@enac.fr>,
        Stephane Chatty <chatty@lii-enac.fr>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/2] autodetection of multitouch devices
Message-ID: <20110926144635.GA6921@polaris.bitmath.org>
References: <1316617015-11648-1-git-send-email-benjamin.tissoires@gmail.com>
 <alpine.LNX.2.00.1109261419330.13109@pobox.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LNX.2.00.1109261419330.13109@pobox.suse.cz>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 26, 2011 at 02:20:08PM +0200, Jiri Kosina wrote:
> On Wed, 21 Sep 2011, Benjamin Tissoires wrote:
> 
> > Hi Guys,
> > 
> > These two patches finally enable the kernel to handle multitouch devices correctly.
> > If a device presents in its report descriptors the usage Contact ID, then it is considered as
> > a multitouch device and handled by hid-multitouch.
> 
> Hi Banjamin,
> 
> thanks a lot for working on this. I have now queued the patches in my 
> tree.

Hi Benjamin,

Late as it seems, here are a couple of questions:

1. How was this tested? By removing all white-listed devices in
hid-multitouch.c to see if the usual suspects are still picked up?

2. Having the device blacklist inside hid-multitouch.c seems awkward.
I can see the benefits of putting it in a module, but is there any
other rationale? Right now the blacklist duplicates the hid whitelist.

Thanks,
Henrik
