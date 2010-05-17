Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755485Ab0EQSvf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 May 2010 14:51:35 -0400
Received: from moutng.kundenserver.de ([212.227.17.10]:52617 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755209Ab0EQSvd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 May 2010 14:51:33 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Greg KH <gregkh@suse.de>
Subject: Re: [PATCH v3 00/10] BKL conversion in tty layer
Date: Mon, 17 May 2010 20:30:23 +0200
User-Agent: KMail/1.12.2 (Linux/2.6.31-19-generic; KDE/4.3.2; x86_64; ; )
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, linux-kernel@vger.kernel.org,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       John Kacur <jkacur@redhat.com>, Al Viro <viro@zeniv.linux.org.uk>,
       Ingo Molnar <mingo@elte.hu>
References: <1273957196-13768-1-git-send-email-arnd@arndb.de> <20100517144130.1d8aa313@lxorguk.ukuu.org.uk> <20100517153055.GA28137@suse.de>
In-Reply-To: <20100517153055.GA28137@suse.de>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201005172030.23741.arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX1/2ZdgIwkGznJOhvUwjz/Eo4CVxLdVof99baUb
 0s13Pt3Fztpj8tcJc25MNdZETwd4HfnNWifxy0RjgR0iJ4nPjD
 0D11pQ8rPaglcr7ThetBA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 17 May 2010, Greg KH wrote:
> 
> I'd prefer to do this for .36, not for .35.  Arnd, I'll be glad to queue
> these patches up to the tty development tree after .35-rc1 is out, so it
> gets lots of testing in the linux-next tree, is that ok?  If so, can you
> resend them to me at that time?

Ok, I'll make sure it still works with .35-rc1 when it's out and add
Alan's ACK, then send a you a pull request. Did you already merge the
series from Alan that this is based on, or do you want those patches
to wait as well? They are in my git tree, so they will be included
in my pull request if they are not in -rc1.

Also, it would be nice if you could merge the first patch of my
series, which should be completely harmless (it just renames
function calls) but having it upstream means that we can
keep the remaining patches that are required for BKL-less
kernels a lot smaller.

	Arnd

