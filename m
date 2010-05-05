Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934533Ab0EEMYn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 May 2010 08:24:43 -0400
Received: from moutng.kundenserver.de ([212.227.126.186]:57775 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932090Ab0EEMYl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 May 2010 08:24:41 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: [PATCH v2 00/13] BKL conversion in tty layer
Date: Wed, 5 May 2010 14:24:35 +0200
User-Agent: KMail/1.12.2 (Linux/2.6.31-19-generic; KDE/4.3.2; x86_64; ; )
Cc: linux-kernel@vger.kernel.org, Greg KH <gregkh@suse.de>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       John Kacur <jkacur@redhat.com>, Al Viro <viro@zeniv.linux.org.uk>,
       Ingo Molnar <mingo@elte.hu>
References: <1273012433-6125-1-git-send-email-arnd@arndb.de> <20100505115205.7d2abc4f@lxorguk.ukuu.org.uk>
In-Reply-To: <20100505115205.7d2abc4f@lxorguk.ukuu.org.uk>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201005051424.36024.arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX1/SCxvYjDIFDZe9jhDTBh2LSmbPiDGvhLQYYeN
 6Gd8DIK+IKyqxH42uDwZmoNTDcrApxIwwC2whXbUfo/DnwqYfd
 XE9VAWNUdImXsSEs6sGyg==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 05 May 2010, Alan Cox wrote:
> On Wed,  5 May 2010 00:33:39 +0200
> Arnd Bergmann <arnd@arndb.de> wrote:
> 
> > This is the second attempt to get the BKL out of the
> > TTY code. I've updated the patches to be based on top
> > of Alan's series and improved a number of things.
> 
> I've updated the patches I first sent out with the fixes for the problems
> you found and send out a new set.

Ok, I've rebased my patches on top of those now and pushed to
git.kernel.org:/pub/scm/linux/kernel/git/arnd/playground.git#bkl/tty,
minus my patch 13/13, which I already mentioned was broken.

	Arnd
