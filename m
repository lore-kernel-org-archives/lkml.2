Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753325Ab1K2I4M (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Nov 2011 03:56:12 -0500
Received: from smtprelay-h22.telenor.se ([195.54.99.197]:58513 "EHLO
	smtprelay-h22.telenor.se" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751958Ab1K2I4K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Nov 2011 03:56:10 -0500
X-SENDER-IP: [85.230.170.8]
X-LISTENER: [smtp.bredband.net]
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AhJJANSc1E5V5qoIPGdsb2JhbABDiUqhKxkBAQEBNzKBcgEBBTocEwEPEAgDGC4UJQoaE4gHt0oSiiljBIxsJ4dAhVWMPg
X-IronPort-AV: E=Sophos;i="4.69,590,1315173600"; 
   d="scan'208";a="4520223"
From: "Henrik Rydberg" <rydberg@euromail.se>
Date: Tue, 29 Nov 2011 09:56:06 +0100
To: Benjamin Tissoires <benjamin.tissoires@enac.fr>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>, Jiri Kosina <jkosina@suse.cz>,
        Stephane Chatty <chatty@lii-enac.fr>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/8] multitouch updates (mainly eGalax)
Message-ID: <20111129085606.GA2354@polaris.bitmath.org>
References: <1322042074-3759-1-git-send-email-benjamin.tissoires@enac.fr>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1322042074-3759-1-git-send-email-benjamin.tissoires@enac.fr>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 23, 2011 at 10:54:26AM +0100, Benjamin Tissoires wrote:
> Hi Guys,
> 
> Here are some multitouch updates.
> Jiri, the first one is already in your upstream-fixes branch, but not in
> your for-next branch...
> 
> Patch 0002 will help end-users to test their device without recompiling the
> hid-multitouch between each test.
> 
> Patches 0003-0008 are focused on eGalax: 
> * I made some cleanup in the #defines for the PIDS.
> * I removed the MT_QUIRK_EGALAX_XYZ_FIXUP as I understood why it was needed
> * I also removed the .maxcontact field in EGALAX as it is not necessary
>   (it was tested on 3 devices: Acer Iconia W500 by Marek, 0xa001 by Cedric,
>    and Windpad 110W by me)
> * I added a few new devices (I included the one reported by Marek and I kept
>   his "From")
> * I included the new protocol for a001 devices (reported by Cedric)

    Acked-by: Henrik Rydberg <rydberg@euromail.se>

Thanks, Benjamin.

Henrik
