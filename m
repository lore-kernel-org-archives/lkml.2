Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754444Ab1HKXuH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Aug 2011 19:50:07 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:60927 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754438Ab1HKXuG convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Aug 2011 19:50:06 -0400
From: =?utf-8?B?TWF0xJtq?= Laitl <matej@laitl.cz>
To: Daniel Mack <zonque@gmail.com>
Cc: Sarah Sharp <sarah.a.sharp@linux.intel.com>,
        Alan Stern <stern@rowland.harvard.edu>,
        Florian Mickler <florian@mickler.org>,
        Oliver Neukum <oliver@neukum.org>, linux-usb@vger.kernel.org,
        alsa-devel@alsa-project.org, Takashi Iwai <tiwai@suse.de>,
        Clemens Ladisch <clemens@ladisch.de>, pedrib@gmail.com,
        William Light <wrl@illest.net>, Greg KH <greg@kroah.com>,
        linux-kernel@vger.kernel.org, Robert Hancock <hancockrwd@gmail.com>
Subject: Re: Allocating buffers for USB transfers (again)
Date: Fri, 12 Aug 2011 01:50:01 +0200
Message-ID: <1451239.ZLFiT5MIDr@edgy>
Organization: FJFI =?UTF-8?B?xIxWVVQ=?=
User-Agent: KMail/4.7.0  (Linux/3.1.0-rc1-00043-ge61d19b; KDE/4.7.0; x86_64; ; )
In-Reply-To: <4E446873.9020508@gmail.com>
References: <Pine.LNX.4.44L0.1108101025250.1917-100000@iolanthe.rowland.org> <3166003.Y8gKYdUrh9@edgy> <4E446873.9020508@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12. 8. 2011 Daniel Mack wrote:
> > This patch actually makes the sound playback _worse_. Now I get strange
> > squawks where previously at least first seconds of a song sounded
> > normally.
> > 
> > However, I no longer get "zero length buffer submitted" or that "...
> > Weird." debug messages, only several megabytes of: (should I post these
> > somewhere?)
> > 
> > xhci_hcd 0000:05:00.0: Giveback URB ffff880114cec000, len = 880,
> > expected = 1000, status = -115
> > xhci_hcd 0000:05:00.0: Giveback URB ffff880114740000, len = 352,
> > expected = 1000, status = -115
> > xhci_hcd 0000:05:00.0: underrun event on endpoint
> 
> Might be the hardware doesn't like this. As I said, the patch is blindly 
> written and I couldn't test it. Did you test this on a EHCI port as well?

Good point, this patch distorts the playback also on the EHCI port. (the 
playback seems to be 10 times slower than it should be)

Now I have to go, but I hope I'll get another patch from you tomorrow. :-)

Thanks,
               Matej

