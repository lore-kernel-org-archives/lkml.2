Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756956Ab0ERLpF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 May 2010 07:45:05 -0400
Received: from nessie.weebeastie.net ([220.233.7.36]:45214 "EHLO
	bunyip.billabong.weebeastie.net" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1756380Ab0ERLpD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 May 2010 07:45:03 -0400
Date: Tue, 18 May 2010 21:44:26 +1000
From: CaT <cat@zip.com.au>
To: Linus Torvalds <torvalds@linux-foundation.org>, bzolnier@gmail.com,
       stable@kernel.org, greg@kroah.com, ben@decadent.org.uk
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Linux 2.6.34 (rt2860 regression)
Message-ID: <20100518114426.GY2657@zip.com.au>
References: <alpine.LFD.2.00.1005161430100.4195@i5.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.1005161430100.4195@i5.linux-foundation.org>
Organisation: Furball Inc.
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, May 16, 2010 at 02:39:36PM -0700, Linus Torvalds wrote:
> So 2.6.34 is out, and the merge window is thus officially open. As usual, 
> I probably won't do any real pulls for a day or two, in the (probably 
> futile) hope that we'll have more people running plain 2.6.34 for a while. 
> But you can certainly start sending me pull requests.
> 
> Go forth and test,

Whilst I realise this is for a staging driver... On 2010/3/4 the firmware
for the rt2860 driver (amongst others) was removed as part of a patch
to get the driver to use request_firmware(). See:

http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=c22202faade08b6b45f14fd86bfb57f79d73464c

The firmware is in the linux-firmware.git repository and has been for a
while (at least I think that's the right firmware):

http://git.kernel.org/?p=linux/kernel/git/airlied/linux-firmware.git;a=history;f=rt2860.bin;h=778a771716aff389c79fec3b245ed00beba23a67;hb=HEAD

Is there any chance of this making it into 2.6.34.1/35 so that the driver
works again as it once did?

-- 
  "A search of his car uncovered pornography, a homemade sex aid, women's 
  stockings and a Jack Russell terrier."
    - http://www.news.com.au/story/0%2C27574%2C24675808-421%2C00.html
