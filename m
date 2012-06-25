Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757381Ab2FYQPY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jun 2012 12:15:24 -0400
Received: from oproxy9.bluehost.com ([69.89.24.6]:58590 "HELO
	oproxy9.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1757180Ab2FYQPW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jun 2012 12:15:22 -0400
Date: Mon, 25 Jun 2012 09:15:42 -0700
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Takashi Iwai <tiwai@suse.de>
Cc: Matthew Garrett <mjg@redhat.com>, platform-driver-x86@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] intel_ips: blacklist HP ProBook laptops
Message-ID: <20120625091542.7ad5e594@jbarnes-x220>
In-Reply-To: <s5h1ul3a6be.wl%tiwai@suse.de>
References: <s5h1ul3a6be.wl%tiwai@suse.de>
X-Mailer: Claws Mail 3.7.8 (GTK+ 2.24.4; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Identified-User: {10642:box514.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 192.55.60.129 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 25 Jun 2012 15:07:17 +0200
Takashi Iwai <tiwai@suse.de> wrote:

> intel_ips driver spews the warning message
>   "ME failed to update for more than 1s, likely hung"
> at each second endlessly on HP ProBook laptops with IronLake.
> 
> As this has never worked, better to blacklist the driver for now.

Sounds like this ME doesn't support the feature.  It would be nice to
have a better way of detecting this, but unless we hear a bunch more
noise like this a one off is fine with me.

Acked-by: Jesse Barnes <jbarnes@virtuousgeek.org>
