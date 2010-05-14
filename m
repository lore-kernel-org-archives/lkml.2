Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752743Ab0ENQaG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 May 2010 12:30:06 -0400
Received: from mail-px0-f174.google.com ([209.85.212.174]:41419 "EHLO
	mail-px0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756178Ab0ENQaA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 May 2010 12:30:00 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=bOzd/vExmKKDS86HkBXCUcJbFGFxw6rCPtT+5iRKZ0u9EhCtL1ihQssTU2oDYcdKDb
         x1TIgKJ0w8iuqFEmh1/ewbTLJGkq4Bs4NuC7Bk8YFQz9ZQ1BSkATYf1Izq5LbaQPK+ms
         FozadZxPjJeRVriCn6YjV3j1g4K3RVOVj2F8k=
Date: Fri, 14 May 2010 09:29:52 -0700
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Matthew Garrett <mjg59@srcf.ucam.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-input@vger.kernel.org, Bastien Nocera <hadess@hadess.net>
Subject: Re: [git pull] Input updates for 2.6.34-rc6
Message-ID: <20100514162951.GB31607@core.coreip.homeip.net>
References: <20100513075728.GF30110@core.coreip.homeip.net>
 <alpine.LFD.2.00.1005130724280.3711@i5.linux-foundation.org>
 <20100514145539.GA5598@srcf.ucam.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100514145539.GA5598@srcf.ucam.org>
User-Agent: Mutt/1.5.20 (2009-08-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 14, 2010 at 03:55:39PM +0100, Matthew Garrett wrote:
> I've done some experimentation under qemu. On ACPI systems, Windows will 
> *only* touch the keyboard controller if there's a device with an 
> appropriate PNP HID or CID and if _STA evaluates to 0x0b or 0x0f. 
> Otherwise it'll simply ignore the hardware entirely. By the looks of it 
> their keyboard probing is also somewhat different to ours, but that's 
> probably another story.
> 
> However, I did find a couple of device IDs that machines may produce 
> which we don't currently check for. I'll send a patch.
> 

I was wondering if we should be matching for _CID instead of _HID for
mouse and keyboard.

-- 
Dmitry
