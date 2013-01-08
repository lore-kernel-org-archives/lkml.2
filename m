Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755892Ab3AHL5E (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jan 2013 06:57:04 -0500
Received: from moutng.kundenserver.de ([212.227.126.186]:63577 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755446Ab3AHL5D (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jan 2013 06:57:03 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Dan Carpenter <dan.carpenter@oracle.com>
Subject: Re: add Packet hub driver for Topcliff Platform controller hub
Date: Tue, 8 Jan 2013 11:56:47 +0000
User-Agent: KMail/1.12.2 (Linux/3.7.0-7-generic; KDE/4.3.2; x86_64; ; )
Cc: masa-korg@dsn.okisemi.com,
        "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, Tomoya MORINAGA <tomoya.rohm@gmail.com>
References: <20130107090210.GA20716@elgon.mountain> <201301081049.15118.arnd@arndb.de> <20130108114846.GQ7302@mwanda>
In-Reply-To: <20130108114846.GQ7302@mwanda>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201301081156.47419.arnd@arndb.de>
X-Provags-ID: V02:K0:acVNeEr2KCrn1sbZW+i49LpXAi1zZPAEau/6A9TfUrX
 +xDqTVKnXqHbFexKmcstDYbPoFty0SUFAciunjUpyWTnasqCr9
 bLpZQsX8DztoFoDTAVGCuwAqQyznPLI/KS42R8ptO//5YDFYho
 v5op+8vJyzuHbM3QNRKomxw/C3fYdGHUtONygYDIgkdu5thsL3
 XWuSRNEZuaCVs5sPOqgireuvktqULaVzqvxEaQflsHHFN8C91F
 XHQqflqijDqYWqk9gcEXpog34g/fsW35iXkCvRFoh4Hz6C5AmP
 MmZdZuIWzmjQ6aasNyYYkpTiI+ckCrR1Ak1YMdrTRGKuJ5e7Le
 xlmti/Rb7+IqfKZO96Ss=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 08 January 2013, Dan Carpenter wrote:
> On Tue, Jan 08, 2013 at 10:49:14AM +0000, Arnd Bergmann wrote:
> > On Monday 07 January 2013, Dan Carpenter wrote:
> > > Sorry my question is about an old patch.  Smatch complains because we
> > > only pass a PAGE_SIZE buffer to sysfs files so the test for
> > > "if (count > PCH_PHUB_OROM_SIZE) {" makes it think we are overflowing.
> > > In fact, count is never more than 4096 so there is no overflow, but I
> > > also think that it means only the first 4096 bytes of the firmware gets
> > > updated.
> > 
> > I think it works correctly as long as user space keeps writing into the
> > bin file when getting short write return (4096 bytes).
> > 
> 
> Ah.  Ok.  I misunderstood.  I've looked through it again and you're
> right.
> 
> Sorry for the noise.

No worries, the report looked totally plausible and I also had to look
up how bin files work.

	Arnd
