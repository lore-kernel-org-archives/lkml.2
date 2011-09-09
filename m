Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759507Ab1IIRdw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Sep 2011 13:33:52 -0400
Received: from mail-yx0-f174.google.com ([209.85.213.174]:48593 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759407Ab1IIRdu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Sep 2011 13:33:50 -0400
Date: Fri, 9 Sep 2011 10:33:43 -0700
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: JJ Ding <jj_ding@emc.com.tw>
Cc: linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
        Seth Forshee <seth.forshee@canonical.com>,
        Aaron Huang <aaron_huang@emc.com.tw>, Tom Lin <tom_lin@emc.com.tw>,
        =?iso-8859-1?Q?=C9ric?= Piel <E.A.B.Piel@tudelft.nl>,
        Daniel Kurtz <djkurtz@chromium.org>,
        Chase Douglas <chase.douglas@canonical.com>,
        Henrik Rydberg <rydberg@euromail.se>,
        Alessandro Rubini <rubini@cvml.unipv.it>
Subject: Re: [PATCH v5 0/8] Input: elantech: add support for newer hardware
Message-ID: <20110909173342.GB13555@core.coreip.homeip.net>
References: <1315189007-2179-1-git-send-email-jj_ding@emc.com.tw>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1315189007-2179-1-git-send-email-jj_ding@emc.com.tw>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi JJ,

On Mon, Sep 05, 2011 at 10:16:39AM +0800, JJ Ding wrote:
> Hi Lists,
> 
> This is a series of patches to add support for newer generations of ELAN
> touchpad.
> 
> Patches #1~#6 are essentially fixes and cleanups that pave the way for
> patch #7 and patch #8, which really adds code for v3 and v4 hardware.
> 
> Any comments, suggestoins are welcome.
> 
> Please take a look at patch #8, which adds support for the latest touchpads from ELAN.
> It is a true multi-touch capable touchpad that can track up to 5 fingers.
> Support is implemented using MT-B protocol. I used synaptics and multitouch X
> driver to test this driver, both worked fine.
> 
> Thank you very much.
> 
> Changes since v1:
> - drop EC workaround patch.
> - add patch #2, make ST and MT have the same range, as Dmitry suggested.
> - add patch #4, remove ETP_EDGE_FUZZ_V2, as Éric suggested.
> - rename all packet checking functions so they are consistent.
> - some code cleanup, and don't report ABS_[XY] when fingers == 0, as Seth suggested.
> - add document for v3 debounce, and now check debounce in elantech_packet_check_v3.
> 
> Changes since v2:
> - fix v3 hardware packet checking (reported by Seth and fix by Dmitry.)
> 
> Changes since v3:
> - fix a tiny style problem (useless space on end-of-line, reported by Seth)
> - v3 hardware can track 2 fingers well, so do not set INPUT_PROP_SEMI_MT on v3
>   (As suggested earlier by Éric.)
> - add patch #8, which adds support for v4 hardware.
> 
> Changes since v4:
> - patch #8: fix a typo (pressure, spotted by Éric)
> - patch #8: add _v4 suffix for functions introduced in this patch (suggested by Éric)
> - patch #8: simplify set_range switch for case 3 and case 4 (suggested by Éric)

OK, I applied all 8 patches to my 3.2 queue (and will push out once
kernel.org is restored) so any followups needs to be sent relative to
these 8.

Thanks.

-- 
Dmitry
