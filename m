Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752527Ab2KMK5S (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Nov 2012 05:57:18 -0500
Received: from comal.ext.ti.com ([198.47.26.152]:48021 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751292Ab2KMK5R (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Nov 2012 05:57:17 -0500
Message-ID: <50A22789.7070103@ti.com>
Date: Tue, 13 Nov 2012 11:57:13 +0100
From: Peter Ujfalusi <peter.ujfalusi@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:16.0) Gecko/20121105 Thunderbird/16.0.1
MIME-Version: 1.0
To: <balbi@ti.com>
CC: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <linux-usb@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-omap@vger.kernel.org>, Kishon Vijay Abraham I <kishon@ti.com>
Subject: Re: [PATCH] usb: otg: twl4030: Change TWL4030_MODULE_* ids to TWL_MODULE_*
References: <1352799818-22363-1-git-send-email-peter.ujfalusi@ti.com> <20121113094722.GB10395@arwen.pp.htv.fi> <50A220BF.7020901@ti.com> <20121113103757.GE10951@arwen.pp.htv.fi>
In-Reply-To: <20121113103757.GE10951@arwen.pp.htv.fi>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/13/2012 11:37 AM, Felipe Balbi wrote:
> ok good. Unfortunately I have already sent this merge window's pull
> request to Greg so I'd have to delay this until v3.9. If that's ok with
> you, I can take it through my tree.

I hoped that this can go with 3.8 since in 3.9 I'm planning to remove all of
these TWL4030_MODULE_* defines which have TWL_MODULE_* counterpart.
In this case I will introduce dummy defines to point to the correct place for
the USB in 3.9 and we can get rid of the rest of these in 3.10. Oh well. This
is going to take a bit longer than I have anticipated.
I can't think of any other subsytem this can go through...

-- 
Péter
