Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754387Ab1ECR6F (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 May 2011 13:58:05 -0400
Received: from kroah.org ([198.145.64.141]:38018 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753248Ab1ECR6D (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 May 2011 13:58:03 -0400
Date: Tue, 3 May 2011 10:49:37 -0700
From: Greg KH <greg@kroah.com>
To: Par-Gunnar Hjalmdahl <par-gunnar.p.hjalmdahl@stericsson.com>
Cc: Greg Kroah-Hartman <gregkh@suse.de>, devel@driverdev.osuosl.org,
        Linus Walleij <linus.walleij@linaro.org>,
        Mathieu Poirier <mathieu.poirier@linaro.org>,
        Linus Walleij <linus.walleij@stericsson.com>,
        Arnd Bergmann <arnd@arndb.de>, Vitaly Wool <vitalywool@gmail.com>,
        Marcel Holtmann <marcel@holtmann.org>, linux-kernel@vger.kernel.org,
        Lukasz Rymanowski <Lukasz.Rymanowski@tieto.com>,
        linux-bluetooth@vger.kernel.org, Pavan Savoy <pavan_savoy@sify.com>,
        Lee Jones <lee.jones@linaro.org>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
        Par-Gunnar Hjalmdahl <pghatwork@gmail.com>
Subject: Re: [PATCH v5] staging: Add ST-Ericsson CG2900 driver
Message-ID: <20110503174937.GA18622@kroah.com>
References: <1303818021-24275-1-git-send-email-par-gunnar.p.hjalmdahl@stericsson.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1303818021-24275-1-git-send-email-par-gunnar.p.hjalmdahl@stericsson.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 26, 2011 at 01:40:21PM +0200, Par-Gunnar Hjalmdahl wrote:
> This patch adds support for the ST-Ericsson CG2900
> Connectivity Combo controller (Bluetooth, FM, GPS).
> 
> Signed-off-by: Par-Gunnar Hjalmdahl <par-gunnar.p.hjalmdahl@stericsson.com>
> Acked-by: Linus Walleij <linus.walleij@linaro.org>

What changed in this version?  It still doesn't apply properly to the
linux-next tree, which shows me that I don't think anything really
changed here.

Can you rediff it so it properly applies (i.e. why are you adding your
driver to the middle of drivers/staging/Makefile and not at the end
which is where it properly belongs?) and resend it?

thanks,

greg k-h
