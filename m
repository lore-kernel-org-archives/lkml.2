Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756566Ab0DIW4u (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Apr 2010 18:56:50 -0400
Received: from terminus.zytor.com ([198.137.202.10]:49351 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756011Ab0DIW4n (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Apr 2010 18:56:43 -0400
Message-ID: <4BBFB06E.6020703@zytor.com>
Date: Fri, 09 Apr 2010 15:55:42 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100330 Fedora/3.0.4-1.fc12 Thunderbird/3.0.4
MIME-Version: 1.0
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
CC: guenter.roeck@ericsson.com, linux-kernel@vger.kernel.org,
       Yinghai <yinghai.lu@oracle.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Bjorn Helgaas <bjorn.helgaas@hp.com>,
       Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
       "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
       "x86@kernel.org" <x86@kernel.org>, Andy Isaacson <adi@hexapodia.org>,
       Thomas Renninger <trenn@suse.de>
Subject: Re: [PATCH] x86: Reserve legacy VGA MMIO area for x86_64 as well
 as x86_32
References: <20100407210628.28364.96982.stgit@bob.kio>	<201004071705.07176.bjorn.helgaas@hp.com>	<4BBD13C3.2060404@oracle.com>	<201004091004.39857.bjorn.helgaas@hp.com>	<4BBF5987.3010100@zytor.com>	<4BBF626A.3060800@oracle.com>	<4BBF70BC.3080809@zytor.com>	<1270839357.1477.758.camel@groeck-laptop>	<4BBF89FE.5040909@zytor.com>	<1270845108.1477.784.camel@groeck-laptop>	<4BBF91C6.9090701@zytor.com>	<20100409234245.4081994a@lxorguk.ukuu.org.uk>	<4BBFAD49.3000208@zytor.com> <20100409235413.1167ff0c@lxorguk.ukuu.org.uk>
In-Reply-To: <20100409235413.1167ff0c@lxorguk.ukuu.org.uk>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/09/2010 03:54 PM, Alan Cox wrote:
> Depending on your definition of "PC". Quite a few early MSDOS systems had
> video elsewhere. Some embedded systems without video use the space for
> other stuff. Lots of ISA 386/486 PCs had cards borrowing the unused bits
> of video space.

With "early MSDOS" I presume you mean pre-386 (early on there were
computer makers who thought the MS-DOS universe would work like the CP/M
universe had), so that doesn't really matter for these purposes.

>> I'm wondering what those legitimate reasons are.  This is particularly
>> so since it affects our ability to deal with very early errors, long
>> before we have enumerated anything.  At this point we can at least lay
>> down bytes in the video area and hope the user can see them.
> 
> Thats why you have the bios equipment byte and video queries.

Yes of course; just because we don't want people to do the wrong thing
doesn't necessarily mean we won't try to be nice about it, as long as it
doesn't cause excessive pains elsewhere.

	-hpa
