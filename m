Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759256Ab0HLH6S (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Aug 2010 03:58:18 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:57010 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754369Ab0HLH6P (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Aug 2010 03:58:15 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=VRLcRtLCTmG2jcp2Y1ace+WOuhCaKVFBhwfvQO8OjLpg37WOITjeIS3nVJ379IOYpP
         FinzDNXUrZ9sLmx16l74fPqkoNaaDv2E0DyHAKtt2aiXCHhOXuIy0LLEnc0zNRbUsKQh
         F/TgayO4UoCAhvrd28hhHHs+z3TsnjV1SwexE=
Subject: Re: [PATCH 2/2] MEMSTICK: Add driver for Ricoh R5C592 Card reader.
From: Maxim Levitsky <maximlevitsky@gmail.com>
To: Alex Dubov <oakad@yahoo.com>
Cc: LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <667152.31831.qm@web37607.mail.mud.yahoo.com>
References: <667152.31831.qm@web37607.mail.mud.yahoo.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 12 Aug 2010 10:58:10 +0300
Message-ID: <1281599890.4115.6.camel@maxim-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2010-08-12 at 00:22 -0700, Alex Dubov wrote: 
> > Maximum I might need to clear page status bits, but I can
> > do that later
> > after I write the block.
> > This won't be any performance impact because amount of bad
> > pages
> > shouldn't be normally greater that zero.
> > (Otherwise there will be data loss...)
> 
> 
> These things do degrade. I think, memsticks do write-verify, so bad blocks
> will appear during write and can be marked as such without any data loss.
> 
> > 
> > One interesting thing that I just want your opinion on is
> > what to do
> > with correctable errors.
> > Common sense suggests to relocate the sector + and mark it
> > bad.
> > But I don't know how common such sectors are, and thus I
> > could do more
> > harm that good by marking too many sectors as bad.
> 
> I agree that number of writes to the media should be kept minimal.
> So bad (in either way) blocks encountered should be logged, but not
> touched, unless the error appears during an actual write/modify operation.
> 
> > 
> > I hope I create ms_block.c soon, and put that old problem
> > to the rest.
> 
> If you have time and desire, try to put a low level format option in - 
> some function to erase all blocks, except the system ones.
> 
> > 
> > As time permits I will also port your driver for xD portion
> > of jMicron
> > device (which I have).
> 
> By the way, I've got some errata for the newer JMicron chipsets. If they
> have not contacted you yet, I'll forward it to you.

Yeah, I didn't done anything at that direction, but eventually I get to
it.


Best regards,
Maxim Levitsky

