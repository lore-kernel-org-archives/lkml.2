Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933180Ab1CaJU5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Mar 2011 05:20:57 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:45978 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932977Ab1CaJUx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Mar 2011 05:20:53 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:from:to:cc:subject:references:date:in-reply-to:message-id
         :user-agent:mime-version:content-type;
        b=HAJiIe2t5qovvohrEB2AAxsNIDgd55sIYqorvhduFFT/bEgx8uU6sjKvCSA5lTA+sn
         Cr+23QTdJdW8CVpqWQLlrur3avMyE1UzY7PBWyUh+ksF5rshXvb3i/IIRbt4URMu1KW7
         EF+3d0/CJ8Cq7pew9mgvhEz/QeuONezBp/+9c=
From: Peter Korsgaard <jacmet@sunsite.dk>
To: John Williams <john.williams@petalogix.com>
Cc: linux-usb@vger.kernel.org,
        Linux Kernel list <linux-kernel@vger.kernel.org>
Subject: Re: c67x00 gadget support?
References: <AANLkTi=Xp3cP-CPeQx-XO45fsZ38qu21fYeDz6rbLe+s@mail.gmail.com>
Date: Thu, 31 Mar 2011 11:20:35 +0200
In-Reply-To: <AANLkTi=Xp3cP-CPeQx-XO45fsZ38qu21fYeDz6rbLe+s@mail.gmail.com>
	(John Williams's message of "Thu, 31 Mar 2011 11:04:39 +1000")
Message-ID: <8739m34pek.fsf@macbook.be.48ers.dk>
User-Agent: Gnus/5.110009 (No Gnus v0.9) Emacs/22.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>>>> "John" == John Williams <john.williams@petalogix.com> writes:

 John> Hi Peter K,
 John> Back in April 2007 you posted a patch series that included a prototype
 John> of gadget support for the c67x00.

 John> http://www.spinics.net/lists/linux-usb-devel/msg04766.html

Yes, long time ago ;)

 John> The host-side stuff is all merged, just wondering what, if
 John> anything, became of the gadget layer?  It was some low level
 John> tweaks on c67x00-drv.c but the majority was in c67x00-udc.[ch]

I'm afraid it never went much further. We ended up not using the gadget
side for that project, and haven't used the chip in any newer designs.

I do remember that we ended up having to patch the bios code running on
the device to get gadget mode running on port B. I'll see if I can find
the latest code somewhere if you're interested.

-- 
Bye, Peter Korsgaard
