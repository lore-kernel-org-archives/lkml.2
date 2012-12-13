Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755020Ab2LMMU0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Dec 2012 07:20:26 -0500
Received: from esgaroth.petrovitsch.at ([78.47.184.11]:5052 "EHLO
	esgaroth.petrovitsch.priv.at" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750819Ab2LMMUZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Dec 2012 07:20:25 -0500
X-Greylist: delayed 3853 seconds by postgrey-1.27 at vger.kernel.org; Thu, 13 Dec 2012 07:20:24 EST
Subject: Re: [RFC GIT PULL] "Nuke 386-DX/SX support" changes for v3.8
From: Bernd Petrovitsch <bernd@petrovitsch.priv.at>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Ingo Molnar <mingo@kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Alan Cox <alan@lxorguk.ukuu.org.uk>
Date: Thu, 13 Dec 2012 12:15:39 +0100
In-Reply-To: <50C8D458.4050006@zytor.com>
References: <20121211111026.GA26507@gmail.com>
	 <CA+55aFzJX-EKC4Z98+KEaca0V27p8PxqZXiPox=TuuhytUTziw@mail.gmail.com>
	 <50C8D458.4050006@zytor.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.0.3 (3.0.3-1.fc15) 
Content-Transfer-Encoding: 7bit
Message-ID: <1355397344.5337.47.camel@thorin>
Mime-Version: 1.0
X-DCC--Metrics: esgaroth.petrovitsch.priv.at; whitelist
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mit, 2012-12-12 at 11:00 -0800, H. Peter Anvin wrote:
[...]
> There were a *bunch* of embedded 486 clones made, some still in 
> production as far as I know, and I wouldn't be surprised if some of them 
> lacked FPU.  I guess we'll see.

And there is an x86 emulator written in Javascript at
http://www.bellard.org/jslinux/.

http://www.bellard.org/jslinux/tech.html says that it (also) lacks an
FPU.

	Bernd
-- 
Bernd Petrovitsch                  Email : bernd@petrovitsch.priv.at
                     LUGA : http://www.luga.at

