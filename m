Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755549Ab1HXIFO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Aug 2011 04:05:14 -0400
Received: from mail-iy0-f198.google.com ([209.85.210.198]:56861 "EHLO
	mail-iy0-f198.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753140Ab1HXIFJ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Aug 2011 04:05:09 -0400
X-Greylist: delayed 496 seconds by postgrey-1.27 at vger.kernel.org; Wed, 24 Aug 2011 04:05:09 EDT
MIME-Version: 1.0
In-Reply-To: <1314164303-30382-1-git-send-email-jj_ding@emc.com.tw>
References: <1314164303-30382-1-git-send-email-jj_ding@emc.com.tw>
From: Daniel Kurtz <djkurtz@chromium.org>
Date: Wed, 24 Aug 2011 15:56:33 +0800
X-Google-Sender-Auth: XAVrVW4kEPqsp_NyRKlTqseetM8
Message-ID: <CAGS+omAj-jo02O0MXZb_JF7+SfyQmmmAr7MA3_hYfead6gszyg@mail.gmail.com>
Subject: Re: [PATCH v2 0/7] Input: elantech: add support for newer hardware
To: JJ Ding <jj_ding@emc.com.tw>
Cc: linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
        Seth Forshee <seth.forshee@canonical.com>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Aaron Huang <aaron_huang@emc.com.tw>, Tom Lin <tom_lin@emc.com.tw>,
        =?ISO-8859-1?Q?=C9ric_Piel?= <E.A.B.Piel@tudelft.nl>,
        Chase Douglas <chase.douglas@canonical.com>,
        Henrik Rydberg <rydberg@euromail.se>,
        Alessandro Rubini <rubini@cvml.unipv.it>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 24, 2011 at 1:38 PM, JJ Ding <jj_ding@emc.com.tw> wrote:
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
>  Input: elantech - correct x, y value range for v2 hardware
>  Input: elantech - get rid of ETP_2FT_XXXX in elantech.h
>  Input: elantech - use firmware provided x, y ranges
>  Input: elantech - remove ETP_EDGE_FUZZ_V2
>  Input: elantech - packet checking for v2 hardware
>  Input: elantech - clean up elantech_init
>  Input: elantech - add v3 hardware support
>
>  Documentation/input/elantech.txt |  125 +++++++++++--
>  drivers/input/mouse/elantech.c   |  387 +++++++++++++++++++++++++++++++-------
>  drivers/input/mouse/elantech.h   |   35 ++--
>  3 files changed, 444 insertions(+), 103 deletions(-)
>
> --
> 1.7.4.1
>
>

Hi JJ,

Thank you for the updating the patch set.
For all 7 patches:
  Acked-by: Daniel Kurtz <djkurtz@chromium.org>
