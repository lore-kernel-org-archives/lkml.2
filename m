Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752044Ab1AQUgY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Jan 2011 15:36:24 -0500
Received: from mail-qw0-f46.google.com ([209.85.216.46]:54483 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750710Ab1AQUgW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Jan 2011 15:36:22 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=oAMDVj6QapgcJ6KJ73Kfnifo/lRPMlQI7qr178zZPMIT6KAZM/6RsBzHhFKfhyYdur
         eyjgt1N++MjWcpbhT9KBxbu0Te2i3rTBq/Vj6+BYKbPjAjc9EuO27mdIXCrJCeUjZ5fF
         5LUsiO+jmXDpIRS8Yk/9XP93KWJNktcpjtEec=
MIME-Version: 1.0
In-Reply-To: <m3pqrxr1vl.fsf@ingo.homenetwork>
References: <m31v4hkmkf.fsf@ingo.homenetwork>
	<201101131423.51640.helmut.schaa@googlemail.com>
	<AANLkTimMVdsGONSD9OmnX2eJk51H5Pzj4K8irHa=E-qx@mail.gmail.com>
	<m3pqrxr1vl.fsf@ingo.homenetwork>
Date: Mon, 17 Jan 2011 21:36:20 +0100
Message-ID: <AANLkTimdSkHFPKSEsEYpEr1jFxhNXuXjPH2dxOnmvj1E@mail.gmail.com>
Subject: Re: BUG in rt2x00lib_txdone() with 2.6.37-rc8
From: Ivo Van Doorn <ivdoorn@gmail.com>
To: Ingo Brunberg <ingo_brunberg@web.de>
Cc: helmut.schaa@googlemail.com, linux-kernel@vger.kernel.org,
        linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Sun, Jan 16, 2011 at 3:58 AM, Ingo Brunberg <ingo_brunberg@web.de> wrote:
> Ivo Van Doorn <ivdoorn@gmail.com> writes:
>
>> This could be, would be interesting to know if compat-wireless also shows
>> this problem. Because the queue refactoring code which should have solved
>> these race conditions was added after 2.6.37.
>
> I really would like to give it a try, but compat-wireless-2011-01-15
> crashes right on module loading. Is there a version known to work?

You could try the rt2x00-special package:
http://kernel.org/pub/linux/kernel/people/ivd/compat-rt2x00.tar.bz2
this is compat-wireless + rt2x00 patches from rt2x00.git.

For me it is working without any crashes..

Ivo
