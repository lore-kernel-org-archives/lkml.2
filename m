Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753215Ab1EWJUw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 May 2011 05:20:52 -0400
Received: from smtprelay-b11.telenor.se ([62.127.194.20]:35590 "EHLO
	smtprelay-b11.telenor.se" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750918Ab1EWJUu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 May 2011 05:20:50 -0400
X-SENDER-IP: [85.230.169.19]
X-LISTENER: [smtp.bredband.net]
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AnJqAB4m2k1V5qkTPGdsb2JhbACJJJx9CwEBAQE3M8I1DoYLBJROijo
X-IronPort-AV: E=Sophos;i="4.65,255,1304287200"; 
   d="scan'208";a="13639586"
From: "Henrik Rydberg" <rydberg@euromail.se>
Date: Mon, 23 May 2011 11:25:52 +0200
To: Benjamin Tissoires <benjamin.tissoires@enac.fr>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>, Jiri Kosina <jkosina@suse.cz>,
        Stephane Chatty <chatty@lii-enac.fr>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] hid-multitouch: cosmetic changes, sort classes and
 devices
Message-ID: <20110523092552.GB13665@polaris.bitmath.org>
References: <1305899974-5641-1-git-send-email-benjamin.tissoires@enac.fr>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1305899974-5641-1-git-send-email-benjamin.tissoires@enac.fr>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 20, 2011 at 03:59:34PM +0200, Benjamin Tissoires wrote:
> This patch sorts the defs for the MT_CLS. I choose to split
> generic classes and device specific ones to be able to add
> more generic classes in the future.
> 
> It also put eGalax devices at their right place (alphabetically)
> in mt_devices.
> 
> Signed-off-by: Benjamin Tissoires <benjamin.tissoires@enac.fr>
> ---

Maybe too late already, but anyways:

    Acked-by: Henrik Rydberg <rydberg@euromail.se>

Thanks,
Henrik
