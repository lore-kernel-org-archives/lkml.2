Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932301Ab1CRQUH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Mar 2011 12:20:07 -0400
Received: from mail.moocowproductions.org ([50.56.82.78]:34390 "EHLO
	mail.moocowproductions.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932121Ab1CRQUE convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Mar 2011 12:20:04 -0400
Subject: Re: 2.6.38: XFS/USB/HW issue, or failing USB stick?
Mime-Version: 1.0 (Apple Message framework v1082)
Content-Type: text/plain; charset=us-ascii
From: Tim Soderstrom <tim@moocowproductions.org>
In-Reply-To: <201103181659.46558.arnd@arndb.de>
Date: Fri, 18 Mar 2011 11:20:01 -0500
Cc: Alan Piszcz <ap@solarrain.com>, linux-kernel@vger.kernel.org,
        linux-usb@vger.kernel.org, Justin Piszcz <jpiszcz@lucidpixels.com>,
        xfs@oss.sgi.com
Content-Transfer-Encoding: 8BIT
Message-Id: <74AA2E38-9C4E-45EB-B810-2B64EC731F24@moocowproductions.org>
References: <alpine.DEB.2.02.1103181104020.30018@p34.internal.lan> <30463798-7ACB-4248-8CDC-CEFCB6ABC0BE@moocowproductions.org> <201103181659.46558.arnd@arndb.de>
To: Arnd Bergmann <arnd@arndb.de>
X-Mailer: Apple Mail (2.1082)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Mar 18, 2011, at 10:59 AM, Arnd Bergmann wrote:

> On Friday 18 March 2011, Tim Soderstrom wrote:
> 
>>> 
>>> However, after some amount of time, the errors occur below, is this USB
>>> stick failing?  Since it has no SMART, is there any other way to verify
>>> the 'health' of a USB stick?
>> 
>> What prompted you to go with XFS over, say, ext2? The journal will generally
>> cause quite a bit more writes onto your USB device. I use ext2 on my CF card 
>> in my NAS for that reason (the spinning media is on XFS of course). I know
>> that's not an answer to your problem but thought I would add it as a suggestion :)
> 
> Using ext2 on flash media instead of ext3 or other file systems is
> recommended a lot, but the situation is actually much more complex.
> In https://lwn.net/Articles/428584/, I explain how these things work
> under the cover. For a drive that can only have very few erase blocks
> open, using a journaled file system will always mean thrashing, but
> for drives with more open erase blocks, it's probably better to
> use a journal than not.

Wow that's a great article, thanks for the link!

Tim

