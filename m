Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753199Ab1FOHEb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Jun 2011 03:04:31 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:36197 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752900Ab1FOHE3 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Jun 2011 03:04:29 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=UtKGneXVnbQUcj5oamE33+J/kOU+xDSGTsQguQGI15yb6Q2HO2CDqCoL8KBa1GeAXU
         p0H+Kn6kKE35LuvON9NIKESeYyifjjTgrmdz1GMP7D1JvcdTl9VqU38cTdPnPrqqvg4T
         ZV9TvHFupYK40o7Rz4VP8Lp2QMaO6mtvBqe9o=
MIME-Version: 1.0
In-Reply-To: <BANLkTimiv5T6cgRjkDfPwjh-c5AivYzhmA@mail.gmail.com>
References: <1308100165.2113.4.camel@Tux>
	<20110615075803.3348b4ec@pluto.restena.lu>
	<BANLkTimiv5T6cgRjkDfPwjh-c5AivYzhmA@mail.gmail.com>
Date: Wed, 15 Jun 2011 15:04:28 +0800
Message-ID: <BANLkTikRxJHa+kgOSObG4LYf4=zDMEoGyg@mail.gmail.com>
Subject: Re: Possible deadlock when suspending framebuffer
From: =?UTF-8?Q?Am=C3=A9rico_Wang?= <xiyou.wangcong@gmail.com>
To: wanlong.gao@gmail.com
Cc: =?UTF-8?Q?Bruno_Pr=C3=A9mont?= <bonbons@linux-vserver.org>,
        Francis Moreau <francis.moro@gmail.com>,
        Paul Mundt <lethal@linux-sh.org>, linux-fbdev@vger.kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 15, 2011 at 2:22 PM, Wanlong Gao <wanlong.gao@gmail.com> wrote:
> On Wed, Jun 15, 2011 at 1:58 PM, Bruno Prémont
> <bonbons@linux-vserver.org> wrote:
>>
>> Hi,
>>
>> On Wed, 15 Jun 2011 09:09:24 Wanlong Gao <wanlong.gao@gmail.com> wrote:
>> > <snip>
>> > Hi Francis:
>> > can you test this patch?
>>
>> Do you have a deadlock trace which you are trying to fix?
> No, I just look at the code and try to fix this but I'm not sure.
> Can you teach me how to have a deadlock trace here?

CONFIG_LOCKDEP=y
