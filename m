Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757171Ab1CRQJ1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Mar 2011 12:09:27 -0400
Received: from mailout01.t-online.de ([194.25.134.80]:44422 "EHLO
	mailout01.t-online.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756789Ab1CRQJV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Mar 2011 12:09:21 -0400
Message-ID: <4D838395.4090500@t-online.de>
Date: Fri, 18 Mar 2011 17:08:53 +0100
From: Knut Petersen <Knut_Petersen@t-online.de>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; de; rv:1.9.2.14) Gecko/20110221 SUSE/3.1.8 Thunderbird/3.1.8
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Jaroslav Kysela <perex@perex.cz>, Takashi Iwai <tiwai@suse.de>,
        Chris Wilson <chris@chris-wilson.co.uk>, jesse.barnes@intel.com,
        gregkh@suse.de, linux-kernel@vger.kernel.org,
        =?ISO-8859-1?Q?David_M=FCller?= <d.mueller@elsoft.ch>
Subject: Re: [BUG][2.6.38] IRQ Lock Inversion / i915 fails
References: <4D81D6F9.3040304@t-online.de> <AANLkTim=R7GVDY0Nt-6q1mjO3vas-qRy7=VxqgWWtz_s@mail.gmail.com>
In-Reply-To: <AANLkTim=R7GVDY0Nt-6q1mjO3vas-qRy7=VxqgWWtz_s@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-ID: X6Ga7EZ6ohkIeJVX0gGZlHMp8-gb2vElWnC+wR7nyRdBi1mUkyryXs8Okz0f7WPgG-
X-TOI-MSGID: ef7308cf-1906-472a-92d2-8d00d26df988
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Bisecting does not work, I'm unable to find a "good" kernel for the
X.Org Server 1.9.3 used by openSuSE 11.4.

2.6.38 combined with X.Org 1.8.0 (openSuSE 11.3) seems to be ok.

The question is: does X.Org 1.9.3 expose an old kernel bug, or
is the X server that screws up the i915 hardware and kernel driver?

cu,
 Knut
