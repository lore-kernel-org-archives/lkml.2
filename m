Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752096Ab1HZO2U (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Aug 2011 10:28:20 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:42467 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750941Ab1HZO2S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Aug 2011 10:28:18 -0400
Date: Fri, 26 Aug 2011 09:28:13 -0500
From: Seth Forshee <seth.forshee@canonical.com>
To: JJ Ding <jj_ding@emc.com.tw>
Cc: linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Aaron Huang <aaron_huang@emc.com.tw>, Tom Lin <tom_lin@emc.com.tw>,
        =?utf-8?B?w4lyaWM=?= Piel <E.A.B.Piel@tudelft.nl>,
        Daniel Kurtz <djkurtz@chromium.org>,
        Chase Douglas <chase.douglas@canonical.com>,
        Henrik Rydberg <rydberg@euromail.se>,
        Alessandro Rubini <rubini@cvml.unipv.it>
Subject: Re: [PATCH v3 7/7] Input: elantech - add v3 hardware support
Message-ID: <20110826142813.GB13381@thinkpad-t410>
Mail-Followup-To: JJ Ding <jj_ding@emc.com.tw>, linux-input@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Dmitry Torokhov <dmitry.torokhov@gmail.com>,
	Aaron Huang <aaron_huang@emc.com.tw>, Tom Lin <tom_lin@emc.com.tw>,
	=?utf-8?B?w4lyaWM=?= Piel <E.A.B.Piel@tudelft.nl>,
	Daniel Kurtz <djkurtz@chromium.org>,
	Chase Douglas <chase.douglas@canonical.com>,
	Henrik Rydberg <rydberg@euromail.se>,
	Alessandro Rubini <rubini@cvml.unipv.it>
References: <1314320591-11551-1-git-send-email-jj_ding@emc.com.tw>
 <1314320591-11551-8-git-send-email-jj_ding@emc.com.tw>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1314320591-11551-8-git-send-email-jj_ding@emc.com.tw>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 26, 2011 at 09:03:11AM +0800, JJ Ding wrote:
> +	/*
> +	 * check debounce first, it has the same signature in byte 0 

Just one pedantic comment -- git complained about trailing whitespace on
this line. Not that important, and Dmitry can clean it up when he
applies the patch if he's so inclined.

This patch looks good now, and it's testing fine for me.

Reviewed-and-Tested-by: Seth Forshee <seth.forshee@canonical.com>

I'm also curious what you found out about whether or not the touchpad
does accurate finger tracking. I've played with it a little, and the
finger tracking has been accurate except for one small exception. When
the fingers are overlapping on one axis the touchpad always reports the
same position for both fingers along that axis. For instance, if I move
one finger up and the other finger down simultaneously on the touchpad,
one of the fingers will show reverse movement on the y axis briefly
while the fingers overlap. But I've never seen the fingers swap between
the two frames of the packet.
