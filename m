Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752132Ab0DLPGJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Apr 2010 11:06:09 -0400
Received: from moutng.kundenserver.de ([212.227.126.171]:54025 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751502Ab0DLPGH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Apr 2010 11:06:07 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Frederic Weisbecker <fweisbec@gmail.com>
Subject: Re: [PATCH 6/6] procfs: Kill the bkl in ioctl
Date: Mon, 12 Apr 2010 17:05:43 +0200
User-Agent: KMail/1.12.2 (Linux/2.6.31-19-generic; KDE/4.3.2; x86_64; ; )
Cc: Alexey Dobriyan <adobriyan@gmail.com>, LKML <linux-kernel@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       John Kacur <jkacur@redhat.com>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       Al Viro <viro@zeniv.linux.org.uk>, Ingo Molnar <mingo@elte.hu>
References: <1269930015-863-1-git-send-regression-fweisbec@gmail.com> <201004011442.38536.arnd@arndb.de> <20100410160945.GF5204@nowhere>
In-Reply-To: <20100410160945.GF5204@nowhere>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201004121705.44030.arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX1+petuppHZkD4QaGgSsr6dWStzvahczZYRtSl5
 0zS8LaiRVvQNI1gyGr3Pljly5AzpyPZ61QGfDJQ5V2s70xS9Yn
 nAyFfFzNH4/WxTfWxvNWw==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 10 April 2010, Frederic Weisbecker wrote:
> Do you mind if I rename this to deprecated_ioctl()?
> This "default" naming suggests a fallback everyone that don't
> need tricky things should use.

Sounds good. The idea was to keep the naming consistent with
default_llseek, but after the discussion on llseek, we will
probably do something else with it anyway.

	Arnd
