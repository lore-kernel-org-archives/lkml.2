Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755629Ab1FTTq1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Jun 2011 15:46:27 -0400
Received: from mailout-de.gmx.net ([213.165.64.22]:34790 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751736Ab1FTTqY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Jun 2011 15:46:24 -0400
X-Authenticated: #12255092
X-Provags-ID: V01U2FsdGVkX1811Sd4RRM1ZbB6gfFyoZ1BbBoNvuZ5g3x/PoTHK4
	77IupTW24SEkY/
From: Peter =?iso-8859-1?q?H=FCwe?= <PeterHuewe@gmx.de>
To: Alexey Dobriyan <adobriyan@gmail.com>
Subject: Re: [PATCH 2/2] mfd/ab8500: Use kstrtoul_from_user
Date: Mon, 20 Jun 2011 21:46:15 +0200
User-Agent: KMail/1.13.5 (Linux/2.6.38.8; KDE/4.4.5; x86_64; ; )
Cc: Samuel Ortiz <sameo@linux.intel.com>,
        Srinidhi Kasagar <srinidhi.kasagar@stericsson.com>,
        Linus Walleij <linus.walleij@stericsson.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Ian Lartey <ian@opensource.wolfsonmicro.com>,
        Dimitris Papastamos <dp@opensource.wolfsonmicro.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org
References: <1307393012-32582-1-git-send-email-peterhuewe@gmx.de> <1307393012-32582-2-git-send-email-peterhuewe@gmx.de> <BANLkTikKRVP4PW48YtR+mMMNsaxTDxoGtw@mail.gmail.com>
In-Reply-To: <BANLkTikKRVP4PW48YtR+mMMNsaxTDxoGtw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201106202146.16585.PeterHuewe@gmx.de>
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Montag 20 Juni 2011, 15:45:46 schrieb Alexey Dobriyan:
> NAK
> You should use kstrtou8_from_user() and drop 0xff check as well.
> 
> Do NOT blindly replace strict_strtoul with kstrtoul.

Thanks for spotting this - I'll review my other patches as well and redo them.
Sorry for any inconvenience.

Thanks,
Peter

