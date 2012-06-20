Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757212Ab2FTQZf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jun 2012 12:25:35 -0400
Received: from smtprelay-b12.telenor.se ([62.127.194.21]:35478 "EHLO
	smtprelay-b12.telenor.se" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754347Ab2FTQZd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jun 2012 12:25:33 -0400
X-SENDER-IP: [85.230.168.62]
X-LISTENER: [smtp.bredband.net]
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Ao9QAFr44U9V5qg+PGdsb2JhbABFihKrPBkBAQEBNzSCGAEBBScTHBMBDxAIAxUDLhQlChoTiA+5VxSLGoU7YAOVKYVmjH0
X-IronPort-AV: E=Sophos;i="4.77,445,1336341600"; 
   d="scan'208";a="359677576"
From: "Henrik Rydberg" <rydberg@euromail.se>
Date: Wed, 20 Jun 2012 18:28:12 +0200
To: "benjamin.tissoires" <benjamin.tissoires@gmail.com>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>, Jiri Kosina <jkosina@suse.cz>,
        Stephane Chatty <chatty@enac.fr>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH Stable 3.4.x] HID: hid-multitouch: fix wrong protocol
 detection
Message-ID: <20120620162812.GA433@polaris.bitmath.org>
References: <1340111206-11659-1-git-send-email-benjamin.tissoires@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1340111206-11659-1-git-send-email-benjamin.tissoires@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 19, 2012 at 03:06:46PM +0200, benjamin.tissoires wrote:
> From: Benjamin Tissoires <benjamin.tissoires@enac.fr>
> 
> The previous implementation introduced a randomness in the splitting
> of the different touches reported by the device. This version is more
> robust as we don't rely on hi->input->absbit, but on our own structure.
> 
> This also prepares hid-multitouch to better support Win8 devices.
> 
> [commit 3ac36d15557d1bedfb1151d9911b9587b2d40759 in Linus' tree]
> 
> Signed-off-by: Benjamin Tissoires <benjamin.tissoires@enac.fr>
> ---
> 
> Hi Jiri,
> 
> This patch is a port of the one included in the future 3.5.
> I already had users complaining about the broken behavior in 3.4, then this
> respin for 3.4. Kernels 3.3 and below are not impacted by the bug.

    Acked-by: Henrik Rydberg <rydberg@euromail.se>

Thanks,
Henrik
