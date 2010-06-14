Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751965Ab0FNSSA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jun 2010 14:18:00 -0400
Received: from ch-smtp03.sth.basefarm.net ([80.76.149.214]:57111 "EHLO
	ch-smtp03.sth.basefarm.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751018Ab0FNSR7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jun 2010 14:17:59 -0400
Message-ID: <4C167245.1050907@euromail.se>
Date: Mon, 14 Jun 2010 20:17:41 +0200
From: Henrik Rydberg <rydberg@euromail.se>
User-Agent: Thunderbird 2.0.0.24 (X11/20100411)
MIME-Version: 1.0
To: Ping Cheng <pinglinux@gmail.com>
CC: Jiri Kosina <jkosina@suse.cz>, Dmitry Torokhov <dmitry.torokhov@gmail.com>,
       linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
       Stephane Chatty <chatty@enac.fr>, Rafi Rubin <rafi@seas.upenn.edu>,
       Michael Poole <mdpoole@troilus.org>
Subject: Re: [PATCH] hid-input: Use a larger event buffer for MT devices
References: <1276516181-4519-1-git-send-email-rydberg@euromail.se> <AANLkTinI8w5vCi-VOf_IybZmOBDe8gjlJymZNSmmpkpk@mail.gmail.com>
In-Reply-To: <AANLkTinI8w5vCi-VOf_IybZmOBDe8gjlJymZNSmmpkpk@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Originating-IP: 83.248.196.134
X-Scan-Result: No virus found in message 1OOEEB-0004RK-CJ.
X-Scan-Signature: ch-smtp03.sth.basefarm.net 1OOEEB-0004RK-CJ 1d1c6dda1f6021cc99d5be157de2398d
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ping Cheng wrote:
[...]
> Do we really want to use a hardcoded number here? Considering you have
> used the same value in your "input: bcm5974" patch, adding it as an
> ifdef in linux/input.h should not be an overkill in design and offers
> the other drivers a chance to use it.

Well, I think it is. The fact that it appears more than once rather points to
the general duplication between HID and special input devices. A function like
"input_device_needs_more_bandwidth()" would be clean, but it just does not seem
worth it.

Henrik

