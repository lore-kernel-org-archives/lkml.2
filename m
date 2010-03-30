Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756257Ab0C3Kik (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Mar 2010 06:38:40 -0400
Received: from moutng.kundenserver.de ([212.227.17.9]:56294 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756245Ab0C3Kii (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Mar 2010 06:38:38 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Frederic Weisbecker <fweisbec@gmail.com>
Subject: Re: [PATCH 3/6] procfs: Use generic_file_llseek in /proc/kmsg
Date: Tue, 30 Mar 2010 11:38:31 +0100
User-Agent: KMail/1.12.2 (Linux/2.6.31-19-generic; KDE/4.3.2; x86_64; ; )
Cc: LKML <linux-kernel@vger.kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       John Kacur <jkacur@redhat.com>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       Al Viro <viro@zeniv.linux.org.uk>, Ingo Molnar <mingo@elte.hu>
References: <1269930015-863-1-git-send-regression-fweisbec@gmail.com> <1269930015-863-4-git-send-regression-fweisbec@gmail.com>
In-Reply-To: <1269930015-863-4-git-send-regression-fweisbec@gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201003301238.32154.arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX19jMhDBTt5i3dB4CPgLiI08XyzL4JS/RCAeAtd
 47xC/6Upgkceq6X6f7sjKRnuMkpDVYviVr5SMpu2LNC1J0J2iD
 v/IysYHKe11uTwfG1bV6w==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 30 March 2010, Frederic Weisbecker wrote:
> No need to hold the bkl to seek here, none of the other
> fops callbacks use it.
> 
> Use generic_file_llseek explicitly.
> 
Acked-by: Arnd Bergmann <arnd@arndb.de>
