Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932872Ab1EZQUr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 May 2011 12:20:47 -0400
Received: from relay2.ptmail.sapo.pt ([212.55.154.22]:34248 "HELO sapo.pt"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S932523Ab1EZQUq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 May 2011 12:20:46 -0400
X-Greylist: delayed 398 seconds by postgrey-1.27 at vger.kernel.org; Thu, 26 May 2011 12:20:45 EDT
X-AntiVirus: PTMail-AV 0.4-0.97.0
X-Scan-Status: AV clean (0.02786 seconds);
 AS clean (0.11200 seconds);
X-Antivirus-bastov-Mail-From: sergio@serjux.com via sergiomb.no-ip.org
X-Antivirus-bastov: 1.25-st-qms (Clear:RC:0(194.65.5.235):SA:0(0.3/5.0):. Processed in 1.202614 secs Process 6362)
Subject: Re: (Short?) merge window reminder
From: =?ISO-8859-1?Q?S=E9rgio?= Basto <sergio@serjux.com>
To: "jonsmirl@gmail.com" <jonsmirl@gmail.com>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, linux-arch@vger.kernel.org,
        linux-mm <linux-mm@kvack.medozas.de>, "Ted Ts'o" <tytso@mit.edu>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        DRI <dri-devel@lists.freedesktop.org>,
        Jan Engelhardt <jengelh@medozas.de>,
        Jacek Luczak <difrost.kernel@gmail.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Date: Thu, 26 May 2011 17:13:57 +0100
In-Reply-To: <BANLkTi=Xuk4=Q43QV1pv33K=J2FFZBLLtQ@mail.gmail.com>
References: <BANLkTi=PLuZhx1=rCfOtg=aOTuC1UbuPYg@mail.gmail.com>
	 <20110523192056.GC23629@elte.hu>
	 <BANLkTikdgM+kSvaEYuQkgCYJZELnvwfetg@mail.gmail.com>
	 <20110523231721.GM10009@thunk.org> <4DDAEC68.30803@zytor.com>
	 <BANLkTikGfVSAMY2a2yiXaNpvBVvF8YdMEA@mail.gmail.com>
	 <alpine.LNX.2.01.1105241409280.15351@frira.zrqbmnf.qr>
	 <BANLkTimCXVdVa6KLRG8GJR1gJY=7_5SkOA@mail.gmail.com>
	 <alpine.LNX.2.01.1105241500410.23085@frira.zrqbmnf.qr>
	 <BANLkTinNK+9XijCN0YGXyvLQ8_npPTG2cQ@mail.gmail.com>
	 <20110524154348.27ba649d@lxorguk.ukuu.org.uk>
	 <BANLkTi=Xuk4=Q43QV1pv33K=J2FFZBLLtQ@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.0.1 (3.0.1-1.fc15) 
Content-Transfer-Encoding: 8bit
Message-ID: <1306426437.6981.14.camel@segulix>
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-05-24 at 11:07 -0400, jonsmirl@gmail.com wrote:
> On Tue, May 24, 2011 at 10:43 AM, Alan Cox <alan@lxorguk.ukuu.org.uk>
> wrote:
> > Can we drop most of MCA, EISA and ISA bus if we are going to have a
> big
> > version change ? A driver spring clean is much overdue and it's all
> in
> > git in case someone wishes to sneak out at midnight and bring some
> crawly
> > horror back from the dead.
> 
> 2.8 could mark the beginning of the great cleanup
>   --- work out the details of what needs to be cleaned and set a goal
>   --- remove old buses/driver, switch to device tree, graphics, 32/64
> merges, etc
> 3.0 would mark its completion 

Here it go my opinion,
Many people ask for beginning of 2.7 kernel series which will end on
2.8, by old numeration. 
Kernel 2.8 will mainly a major clean up, of support of the very old
hardware, like "math co-processor" at only exist in 386 and before
Pentium. If some one want put Linux on this very old hardware should use
kernel 2.2.
However a new numeration of kernel is independent of this, and I agree
with new numeration of kernel on drop a number. 
Last but not least, I would like to see marked a hiper stable kernel ,
which will be used by Debian guys. Debian guys tend to stop in a kernel
which is not the best one, so let we choose for them what is the stable
of stables .    

Best regards, 
-- 
Sérgio M. B.

