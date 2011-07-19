Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752632Ab1GSI5J (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Jul 2011 04:57:09 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:36901 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752177Ab1GSI5H convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Jul 2011 04:57:07 -0400
From: "Nori, Sekhar" <nsekhar@ti.com>
To: Jon Povey <jon.povey@racelogic.co.uk>,
        "davinci-linux-open-source@linux.davincidsp.com" 
	<davinci-linux-open-source@linux.davincidsp.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Hilman, Kevin" <khilman@ti.com>
Date: Tue, 19 Jul 2011 14:26:50 +0530
Subject: RE: [PATCH] davinci: fix DM365 EVM video input mux bits
Thread-Topic: [PATCH] davinci: fix DM365 EVM video input mux bits
Thread-Index: AcxFxD5hhNPK8ViZSWG/qNNzboc5ygALC/+Q
Message-ID: <B85A65D85D7EB246BE421B3FB0FBB593024DBDC68A@dbde02.ent.ti.com>
References: <1311046211-2849-1-git-send-email-jon.povey@racelogic.co.uk>
In-Reply-To: <1311046211-2849-1-git-send-email-jon.povey@racelogic.co.uk>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jon,

On Tue, Jul 19, 2011 at 09:00:11, Jon Povey wrote:
> Video input mux settings for tvp7002 and imager inputs were swapped.
> Comment was correct.
> 
> Tested on EVM with tvp7002 input.
> 
> Signed-off-by: Jon Povey <jon.povey@racelogic.co.uk>

Thanks for the fix.

Since this part of the code hasn't changed since it
was written, this is a good candidate for stable
kernel series. You can just add:

Cc: stable@kernel.org

Also, this way if the fix fails to make it to 3.0,
it can make it into its stable series. I will add
the Cc line when I queue this patch.

> ---
> As a bugfix maybe this should try to get into 3.0?

I am going queue this to Arnd for sending it for v3.0.
He hasn't yet picked up my earlier pull request yet so
keep fingers crossed :)

BTW, I changed the subject to:

"davinci: DM365 EVM: fix video input mux bits"

Nothing really wrong with what you had, just that
I prefer it this way.

Thanks,
Sekhar

