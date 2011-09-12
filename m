Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754047Ab1ILIoX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Sep 2011 04:44:23 -0400
Received: from mailservice.tudelft.nl ([130.161.131.5]:42773 "EHLO
	mailservice.tudelft.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753703Ab1ILIoV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Sep 2011 04:44:21 -0400
X-Spam-Flag: NO
X-Spam-Score: -22.91
Message-ID: <4E6DC664.7090909@tudelft.nl>
Date: Mon, 12 Sep 2011 10:44:20 +0200
From: =?UTF-8?B?w4lyaWMgUGllbA==?= <E.A.B.Piel@tudelft.nl>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:6.0.2) Gecko/20110907 Thunderbird/6.0.2
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
Subject: Re: [PATCH v5 0/8] Input: elantech: add support for newer hardware
References: <1315189007-2179-1-git-send-email-jj_ding@emc.com.tw>
In-Reply-To: <1315189007-2179-1-git-send-email-jj_ding@emc.com.tw>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Op 05-09-11 04:16, JJ Ding schreef:
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
Hello,
I've tested this series (plus the patch for debounce packet on v2) on my 
old v2 hardware, and it worked fine :-)

Éric

