Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755515Ab1HaMyN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Aug 2011 08:54:13 -0400
Received: from mailservice.tudelft.nl ([130.161.131.5]:59480 "EHLO
	mailservice.tudelft.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755376Ab1HaMyL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Aug 2011 08:54:11 -0400
X-Spam-Flag: NO
X-Spam-Score: -22.91
Message-ID: <4E5E2EEF.8050405@tudelft.nl>
Date: Wed, 31 Aug 2011 14:54:07 +0200
From: =?UTF-8?B?w4lyaWMgUGllbA==?= <E.A.B.Piel@tudelft.nl>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:6.0) Gecko/20110823 Thunderbird/6.0
MIME-Version: 1.0
To: JJ Ding <jj_ding@emc.com.tw>
CC: linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
        Seth Forshee <seth.forshee@canonical.com>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Aaron Huang <aaron_huang@emc.com.tw>, Tom Lin <tom_lin@emc.com.tw>,
        Daniel Kurtz <djkurtz@chromium.org>,
        Chase Douglas <chase.douglas@canonical.com>,
        Henrik Rydberg <rydberg@euromail.se>,
        Alessandro Rubini <rubini@cvml.unipv.it>
Subject: Re: [PATCH v4 0/8] Input: elantech: add support for newer hardware
References: <1314606539-24722-1-git-send-email-jj_ding@emc.com.tw>
In-Reply-To: <1314606539-24722-1-git-send-email-jj_ding@emc.com.tw>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Op 29-08-11 10:28, JJ Ding schreef:
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
Hello,
IMHO, this patch series is starting to look really good.

For patches 1-7 you have my:

Acked-by: Éric Piel <eric.piel@tremplin-utc.net>

I've just some little comments on patch 8.

I'll try find the time to test on my laptop (with touchpad firmware 
version 2) this weekend.

Cheers,
Éric
