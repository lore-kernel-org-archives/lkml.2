Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755410Ab0G1Pg6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jul 2010 11:36:58 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:46709 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751381Ab0G1Pg4 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jul 2010 11:36:56 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=LCPHZ9N0oiBt5sRePY+HWtZqoWyu7IG4TjJbgguHqtVCmrMtXH+0CH9EubyX1XfzOL
         xLw+x64ieQKjsdB57xyvbYlqtaF0gZBv+SL6CklhbppDyNdI8WzkeZJCdXsgAYHc0OFq
         S4G3QulxTfvpHp9eQ8bKy1HKmqjJuvYw9z6s8=
MIME-Version: 1.0
In-Reply-To: <1280311240.24054.103.camel@Joe-Laptop.home>
References: <1280258531.24054.10.camel@Joe-Laptop.home> <AANLkTi=p=-ovBaqyqBdEW=W4E1ArWsiyUBwy37GtXOyu@mail.gmail.com> 
	<1280311240.24054.103.camel@Joe-Laptop.home>
From: Mike Frysinger <vapier.adi@gmail.com>
Date: Wed, 28 Jul 2010 11:36:35 -0400
Message-ID: <AANLkTimHYS8BRBbomxwyqwayu8eyp+k6TurtsniNTMfs@mail.gmail.com>
Subject: Re: [Uclinux-dist-devel] [PATCH net-next] drivers/net/bfin_mac.c: Use 
	pr_fmt, netdev_<level>
To: Joe Perches <joe@perches.com>
Cc: Michael Hennerich <michael.hennerich@analog.com>,
        uclinux-dist-devel <uclinux-dist-devel@blackfin.uclinux.org>,
        LKML <linux-kernel@vger.kernel.org>, netdev <netdev@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 28, 2010 at 06:00, Joe Perches wrote:
> On Wed, 2010-07-28 at 03:50 -0400, Mike Frysinger wrote:
>> On Tue, Jul 27, 2010 at 15:22, Joe Perches wrote:
>> > $ ./scripts/checkpatch.pl -f drivers/net/bfin_mac.c | grep "^total:"
>> > total: 2 errors, 25 warnings, 1723 lines checked
>> > $ ./scripts/checkpatch.pl -f drivers/net/bfin_mac.c | grep "^total:"
>> > total: 0 errors, 0 warnings, 1743 lines checked
>> i dislike the mixing of whitespace and useful changes
>> if they were split, and they worked, then i wouldnt have a problem with them
>
> Is that a nak or a dislike?

if you arent going to bother fixing things, then i guess it's a NAK ;)

> Also, is Michael Hennerich actually the maintainer for bfin_mac?
> He had been  listed as MAINTAINER for over a year but he hasn't
> ever written or acked a patch for this file.

i dont know what log you're reading, but i see Michael making plenty
of changes to this driver
-mike
