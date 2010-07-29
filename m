Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758035Ab0G2QZX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Jul 2010 12:25:23 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:59840 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757926Ab0G2QZV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Jul 2010 12:25:21 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type;
        b=CwE5FuNZkXXmUISgf9NCeNAZiKv5RMEMvgPVD5lF+5G/EPyeK4FPN7vFcWVTCJkX24
         hRBK1NGTPP+caA7iu8AYiKI3V7XWcgZg7aW5q6G959tVFsPbYf4gzwFrzsp5Hf4AFwyO
         DpPWhR0KTA3HrLII7KOYG8jMZhl9gLd+JJgis=
MIME-Version: 1.0
In-Reply-To: <AANLkTimHYS8BRBbomxwyqwayu8eyp+k6TurtsniNTMfs@mail.gmail.com>
References: <1280258531.24054.10.camel@Joe-Laptop.home> <AANLkTi=p=-ovBaqyqBdEW=W4E1ArWsiyUBwy37GtXOyu@mail.gmail.com> 
	<1280311240.24054.103.camel@Joe-Laptop.home> <AANLkTimHYS8BRBbomxwyqwayu8eyp+k6TurtsniNTMfs@mail.gmail.com>
From: Mike Frysinger <vapier.adi@gmail.com>
Date: Thu, 29 Jul 2010 12:24:59 -0400
Message-ID: <AANLkTimP25dxJj0jXco9GYeTV-Hnk1EwiMFo82i3mW9a@mail.gmail.com>
Subject: Re: [Uclinux-dist-devel] [PATCH net-next] drivers/net/bfin_mac.c: Use 
	pr_fmt, netdev_<level>
To: Joe Perches <joe@perches.com>
Cc: Michael Hennerich <michael.hennerich@analog.com>,
        uclinux-dist-devel <uclinux-dist-devel@blackfin.uclinux.org>,
        LKML <linux-kernel@vger.kernel.org>, netdev <netdev@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 28, 2010 at 11:36, Mike Frysinger wrote:
> On Wed, Jul 28, 2010 at 06:00, Joe Perches wrote:
>> On Wed, 2010-07-28 at 03:50 -0400, Mike Frysinger wrote:
>>> On Tue, Jul 27, 2010 at 15:22, Joe Perches wrote:
>>> > $ ./scripts/checkpatch.pl -f drivers/net/bfin_mac.c | grep "^total:"
>>> > total: 2 errors, 25 warnings, 1723 lines checked
>>> > $ ./scripts/checkpatch.pl -f drivers/net/bfin_mac.c | grep "^total:"
>>> > total: 0 errors, 0 warnings, 1743 lines checked
>>> i dislike the mixing of whitespace and useful changes
>>> if they were split, and they worked, then i wouldnt have a problem with them
>>
>> Is that a nak or a dislike?
>
> if you arent going to bother fixing things, then i guess it's a NAK ;)

to be clear, i dont have a problem with the direction you're going
with things, just the steps to get there.  i dont like throwing up
"NAK" at postings because that often sounds like a "f-you!" in my
head.  i'd rather suggest changes and then ACK the updated patch(es).
-mike
