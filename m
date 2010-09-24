Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756640Ab0IXN71 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Sep 2010 09:59:27 -0400
Received: from imr3.ericy.com ([198.24.6.13]:57628 "EHLO imr3.ericy.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756542Ab0IXN7Z (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Sep 2010 09:59:25 -0400
Date: Fri, 24 Sep 2010 06:58:02 -0700
From: Guenter Roeck <guenter.roeck@ericsson.com>
To: Takashi Iwai <tiwai@suse.de>
CC: Andrew Morton <akpm@linux-foundation.org>,
        Samu Onkalo <samu.p.onkalo@nokia.com>,
        =?iso-8859-1?Q?=C9ric?= Piel <Eric.Piel@tremplin-utc.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "lm-sensors@lm-sensors.org" <lm-sensors@lm-sensors.org>
Subject: Re: [PATCH v2] lis3: Fix Oops with NULL platform data
Message-ID: <20100924135802.GA18109@ericsson.com>
References: <s5heiclngqe.wl%tiwai@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <s5heiclngqe.wl%tiwai@suse.de>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 23, 2010 at 01:58:33AM -0400, Takashi Iwai wrote:
> The recent addition of threaded irq handler causes a NULL dereference
> when used with hp_accel driver, which has NULL pdata.
> 
> Acked-by: Samu Onkalo <samu.p.onkalo@nokia.com>
> Acked-by: Acked-by: Guenter Roeck <guenter.roeck@ericsson.com>
> Cc: <stable@kernel.org>
> Signed-off-by: Takashi Iwai <tiwai@suse.de>

Applied.

Thanks,
Guenter
