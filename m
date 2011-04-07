Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757055Ab1DGAsb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Apr 2011 20:48:31 -0400
Received: from mail.wdtv.com ([66.118.69.84]:54819 "EHLO mail.wdtv.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756999Ab1DGAsa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Apr 2011 20:48:30 -0400
From: Gene Heskett <gene.heskett@gmail.com>
To: Michal Marek <mmarek@suse.cz>
Subject: Re: 2.6.38.2-New, apparently undfined var in include/linux/Kbuild breaks make headers_install
Date: Wed, 6 Apr 2011 20:48:14 -0400
User-Agent: KMail/1.13.6 (Linux/2.6.38.2-pclos1.pae; KDE/4.6.2; i686; ; )
Cc: linux-kernel@vger.kernel.org
References: <201104061543.14218.gene.heskett@gmail.com> <4D9CDEA4.20102@suse.cz>
In-Reply-To: <4D9CDEA4.20102@suse.cz>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201104062048.14222.gene.heskett@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday, April 06, 2011, Michal Marek wrote:
>On 6.4.2011 21:43, Gene Heskett wrote:
>> This is, in line 25 is $(INSTALL_HDR_PATH)
>> 
>> What do I export as that $VAR that will satisfy this?
>
>It is set by the toplevel Makefile:
>
>#Default location for installed headers
>export INSTALL_HDR_PATH = $(objtree)/usr
>
>What exactly are you doing and how does it fail?
>
>Michal
I was attempting to locally build and install the 2.6.28.2 source package 
from the pclos repo.  My 'makeit' script makes a BzImage then modules.  It 
is about 4 lines into the make modules when it bailed out if that option 
was checked in a make xconfig, and then my makeit script, which was doing 
it after the make modules_install, also bailed out with the same message.

Could it be that my doing the build sequencing by script, was somehow 
bypassing this export function above?

In which case what pre-function should I issue from my script so this 
particular function is not bypassed?

Or might this be considered a Makefile bug?

Its all moot now anyway, I have had synaptic install the ready made pae 
version from the pclos repo, and it seems to be working normally for about 
the last 45 minutes.

Thank you very much for the informative reply Michal.

-- 
Cheers, Gene
"There are four boxes to be used in defense of liberty:
 soap, ballot, jury, and ammo. Please use in that order."
-Ed Howdershelt (Author)
<http://tinyurl.com/ddg5bz>
<http://www.cantrip.org/gatto.html>
Weiner's Law of Libraries:
	There are no answers, only cross references.
