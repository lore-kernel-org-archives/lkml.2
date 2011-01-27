Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753072Ab1A0PAO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Jan 2011 10:00:14 -0500
Received: from ironport2-out.teksavvy.com ([206.248.154.181]:27904 "EHLO
	ironport2-out.pppoe.ca" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752059Ab1A0PAJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Jan 2011 10:00:09 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: ApIBAIsWQU1Ld/sX/2dsb2JhbAAMhAjMXJBigSODOHQEhRc
X-IronPort-AV: E=Sophos;i="4.60,386,1291611600"; 
   d="scan'208";a="89415772"
Message-ID: <4D418877.6030503@teksavvy.com>
Date: Thu, 27 Jan 2011 10:00:07 -0500
From: Mark Lord <kernel@teksavvy.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-GB; rv:1.9.2.13) Gecko/20101207 Thunderbird/3.1.7
MIME-Version: 1.0
To: Mauro Carvalho Chehab <mchehab@redhat.com>
CC: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        linux-input@vger.kernel.org, linux-media@vger.kernel.org
Subject: Re: 2.6.36/2.6.37: broken compatibility with userspace input-utils
 ?
References: <20110125205453.GA19896@core.coreip.homeip.net> <4D3F4804.6070508@redhat.com> <4D3F4D11.9040302@teksavvy.com> <20110125232914.GA20130@core.coreip.homeip.net> <20110126020003.GA23085@core.coreip.homeip.net> <4D403855.4050706@teksavvy.com> <4D40C3D7.90608@teksavvy.com> <4D40C551.4020907@teksavvy.com> <20110127021227.GA29709@core.coreip.homeip.net> <4D40E41D.2030003@teksavvy.com> <20110127063815.GA29924@core.coreip.homeip.net> <4D414928.80801@redhat.com>
In-Reply-To: <4D414928.80801@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11-01-27 05:30 AM, Mauro Carvalho Chehab wrote:
..
> 0.8.2 is the new version that was released in Jan, 25. One of the major
> differences is that it now installs the udev rules, with make install.

Oh, and there's no "make uninstall" option in the Makefile, either.
Where does it put those tentacles, so that I can delete them again ?

> On my tests here, this is working fine, with Fedora and RHEL 6, on my
> usual test devices, so I don't believe that the tool itself is broken, 
> nor I think that the issue is due to the fix patch.

Well, all I know is that it does NOT segfault without the patch,
and now it does.  At this point I should refer you back to Linus's
posts earlier in this thread for the definition of "breaks userspace".

> I remember that when Kay added a persistence utility tool that opens a V4L
> device in order to read some capabilities, this caused a race condition
> into a number of drivers that use to register the video device too early.
> The result is that udev were opening the device before the end of the
> register process, causing OOPS and other problems.
> 
> I suspect that Mark may be experiencing a similar issue.

Could be.  I really don't know.
Again, I could not care less about ir-keyboard,
as I don't use it here at all.

But also again, this thread isn't about what I need fixed,
but rather about broken userspace from 2.6.36 onward.
And the patch to "fix" it seems to possibly cause more breakage.

Cheers
