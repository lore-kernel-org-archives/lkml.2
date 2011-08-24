Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756332Ab1HXFtM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Aug 2011 01:49:12 -0400
Received: from emcscan.emc.com.tw ([192.72.220.5]:28179 "EHLO
	emcscan.emc.com.tw" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752653Ab1HXFtK convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Aug 2011 01:49:10 -0400
From: JJ Ding <jj_ding@emc.com.tw>
To: linux-input@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Seth Forshee <seth.forshee@canonical.com>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Aaron Huang <aaron_huang@emc.com.tw>, Tom Lin <tom_lin@emc.com.tw>,
        =?utf-8?Q?=C3=89ric?= Piel <E.A.B.Piel@tudelft.nl>,
        Daniel Kurtz <djkurtz@chromium.org>,
        Chase Douglas <chase.douglas@canonical.com>,
        Henrik Rydberg <rydberg@euromail.se>,
        Alessandro Rubini <rubini@cvml.unipv.it>
Subject: Re: [PATCH v2 0/7] Input: elantech: add support for newer hardware
In-Reply-To: <1314164303-30382-1-git-send-email-jj_ding@emc.com.tw>
References: <1314164303-30382-1-git-send-email-jj_ding@emc.com.tw>
User-Agent: Notmuch/0.5 (http://notmuchmail.org) Emacs/23.2.1 (i686-pc-linux-gnu)
Date: Wed, 24 Aug 2011 13:51:17 +0800
Message-ID: <87wre31hnu.fsf@emc.com.tw>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sorry.
linux-kernel and linux-input complains patch #2's subject
ETP_2FT_XXXX looks like spam.
(5.1.0 - Unknown address error 550-'5.7.1 Content-Policy reject msg: The
capital Triple-X in subject is way too often associated with junk email,
please rephrase.  BF:<H 0>; S1752956Ab1HXFgV'
)
so patch #2 is blocked.
Please ignore this series.
I will rephase and resend.

Sorry for the noise.

jj

On Wed, 24 Aug 2011 13:38:16 +0800, JJ Ding <jj_ding@emc.com.tw> wrote:
> Hi Lists,
> 
> This is a series of patches to add support for newer generation of ELAN
> touchpad.
> 
> Patches #1~#6 are essentially fixes and cleanups that pave the way for
> patch #7, which really adds code for v3 hardware.
> 
> Any comments, suggestoins are welcome.
> 
> Thank you.
> 
> Changes since v1:
> - drop EC workaround patch.
> - add patch #2, make ST and MT have the same range, as Dmitry suggested.
> - add patch #4, remove ETP_EDGE_FUZZ_V2, as Éric suggested.
> - rename all packet checking functions so they are consistent.
> - some code cleanup, and don't report ABS_[XY] when fingers == 0, as Seth suggested.
> - add document for v3 debounce, and now check debounce in elantech_packet_check_v3.
> 
> JJ Ding (7):
>   Input: elantech - correct x, y value range for v2 hardware
>   Input: elantech - get rid of ETP_2FT_XXXX in elantech.h
>   Input: elantech - use firmware provided x, y ranges
>   Input: elantech - remove ETP_EDGE_FUZZ_V2
>   Input: elantech - packet checking for v2 hardware
>   Input: elantech - clean up elantech_init
>   Input: elantech - add v3 hardware support
> 
>  Documentation/input/elantech.txt |  125 +++++++++++--
>  drivers/input/mouse/elantech.c   |  387 +++++++++++++++++++++++++++++++-------
>  drivers/input/mouse/elantech.h   |   35 ++--
>  3 files changed, 444 insertions(+), 103 deletions(-)
> 
> -- 
> 1.7.4.1
> 
