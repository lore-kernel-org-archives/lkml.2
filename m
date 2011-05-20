Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757195Ab1ETCam (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 May 2011 22:30:42 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:63255 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755945Ab1ETCal convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 May 2011 22:30:41 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=mjtwU6gJVoug0XmorFPe5zH94Lv+PkOXp4OCYm9J0VjjMjUNZaXU5LqkxEr8nmVnC6
         ShvUsnaTE6BPH2SSmUrPExNza3D5dxBTP4WPVNtiRHgIQyNHeuewCm4tuGd6wiW7fIxD
         /9ZTusEhXw5s3oJCvUQ9Q5E6ZcgDUscsYuguU=
MIME-Version: 1.0
In-Reply-To: <20110520002401.GA17623@kroah.com>
References: <2db81796703063c0816d0d99040c6fbd6da50007.1305847719.git.mfm@muteddisk.com>
	<20110520000013.GA8908@kroah.com>
	<BANLkTik=S-FRB25gNHcb0OLMW5dhqLE1eA@mail.gmail.com>
	<20110520002401.GA17623@kroah.com>
Date: Thu, 19 May 2011 19:30:39 -0700
Message-ID: <BANLkTi=FZ57TrOa48qxkO6Myf0pwgtPp7g@mail.gmail.com>
Subject: Re: [PATCH] staging: usbip: replace usbip_u{dbg,err,info} and printk
 with dev_ and pr_
From: matt mooney <mfmooney@gmail.com>
To: Greg KH <greg@kroah.com>
Cc: matt mooney <mfm@muteddisk.com>, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 19, 2011 at 5:24 PM, Greg KH <greg@kroah.com> wrote:
> On Thu, May 19, 2011 at 05:17:45PM -0700, matt mooney wrote:
>> On Thu, May 19, 2011 at 5:00 PM, Greg KH <greg@kroah.com> wrote:
>> > Also, the merge window for the .40 tree for the staging tree is now
>> > closed, so I'll only take bugfixes for the usbip code for now.
>>
>> The userspace code isn't getting merged in .40, is it? Because my
>> patch "staging: usbip: userspace: stub_driver.c: update kernel module
>> name" actually relies on a change in my own tree, so I made a mistake
>> by thinking that it was needed right away to get the userspace tools
>> working.
>
> It's in my tree, so yes.  You can send me patches to fix the problem, as
> I would recommend :)

Can I send you a 10 patch series (or 9 if you apply the patch in this
thread)? The changes I have that fix that are towards the end. The
problem is a lot of my changes rely on the patch sent in this thread
and one that follows it, so to avoid any conflicts it is easiest (at
least for me :) to just send the whole series. They have been tested
and pretty much leave usbip in the state it was originally in.

Thanks,
matt

-- 
GPG-Key: 9AFE00EA
