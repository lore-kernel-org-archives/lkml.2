Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752169Ab1APMX4 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Jan 2011 07:23:56 -0500
Received: from na3sys009aog114.obsmtp.com ([74.125.149.211]:57581 "EHLO
	na3sys009aog114.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752098Ab1APMXw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Jan 2011 07:23:52 -0500
Date: Sun, 16 Jan 2011 14:23:46 +0200
From: Felipe Balbi <balbi@ti.com>
To: Dave Airlie <airlied@gmail.com>
Cc: balbi@ti.com, Chris Wilson <chris@chris-wilson.co.uk>,
        linux-kernel@vger.kernel.org, David Airlie <airlied@linux.ie>,
        dri-devel@lists.freedesktop.org
Subject: Re: [PATCH 1/2] drm: fixup headers_check
Message-ID: <20110116122346.GA4361@legolas.emea.dhcp.ti.com>
Reply-To: balbi@ti.com
References: <1295174783-4099-1-git-send-email-balbi@ti.com>
 <0d30dc$kp159h@orsmga001.jf.intel.com>
 <20110116111616.GC2456@legolas.emea.dhcp.ti.com>
 <20110116111809.GD2456@legolas.emea.dhcp.ti.com>
 <AANLkTikD2gy9PVd=2N_iQEXNRZ-5x725asoeZQZBruOU@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AANLkTikD2gy9PVd=2N_iQEXNRZ-5x725asoeZQZBruOU@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Sun, Jan 16, 2011 at 09:42:37PM +1000, Dave Airlie wrote:
> I'll push the attached I think this time.

the point of headers_check is exactly to prevent indirect inclusion.
This is even 1st topic o SubmitChecklist:

" 1: If you use a facility then #include the file that defines/declares
that facility.  Don't depend on other header files pulling in that you use."

-- 
balbi
