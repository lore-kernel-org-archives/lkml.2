Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756233Ab0C3K2P (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Mar 2010 06:28:15 -0400
Received: from moutng.kundenserver.de ([212.227.17.8]:60270 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756209Ab0C3K2N (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Mar 2010 06:28:13 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Frederic Weisbecker <fweisbec@gmail.com>
Subject: Re: [PATCH 2/6] procfs: Use generic_file_llseek in /proc/kcore
Date: Tue, 30 Mar 2010 11:28:06 +0100
User-Agent: KMail/1.12.2 (Linux/2.6.31-19-generic; KDE/4.3.2; x86_64; ; )
Cc: LKML <linux-kernel@vger.kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       John Kacur <jkacur@redhat.com>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       Al Viro <viro@zeniv.linux.org.uk>, Ingo Molnar <mingo@elte.hu>
References: <1269930015-863-1-git-send-regression-fweisbec@gmail.com> <1269930015-863-3-git-send-regression-fweisbec@gmail.com>
In-Reply-To: <1269930015-863-3-git-send-regression-fweisbec@gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201003301228.06607.arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX18LzAAg3grsV7mSK+suDUVYjlZFEJo3e3uVuuf
 7i/O0Wdx58oSwLKy63XOh4esfAw+sRGAdAvygrzll+ro/Z3wa9
 TIu52I4R6BAIc+YHx8jdg==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 30 March 2010, Frederic Weisbecker wrote:
> /proc/kcore has no llseek and then falls down to use default_llseek.
> This is racy against read_kcore() that directly manipulates fpos
> but it doesn't hold the bkl there so using it in llseek doesn't
> protect anything.

Acked-by: Arnd Bergmann <arnd@arndb.de>
