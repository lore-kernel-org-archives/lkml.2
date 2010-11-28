Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751810Ab0K1UHI (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Nov 2010 15:07:08 -0500
Received: from mail-ww0-f44.google.com ([74.125.82.44]:46261 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751154Ab0K1UHF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Nov 2010 15:07:05 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=gQUVk5zqkgtz9ZmNBXZ8Gb7fYhFNZgakzqXg28TdnNyWpYjzgsSicRKhUaHVBmc+b0
         0aH/JR/7gzPp23tldrn6gZeWtKJjqyYtEndKsa6PfTif3CVuXcZxYfDVecG6+zL7ll7Y
         w4KQ0GDpBi1tDLMQXOsXMDTngfCkEV6BMwjPA=
MIME-Version: 1.0
In-Reply-To: <AANLkTi=2O80uDo4DvjVj14Q0DGqTcZMQmnd-q2XV6f4K@mail.gmail.com>
References: <AANLkTimjMR4wUYCfi7BoUcg6aBmuWcQW_dBo8svReWcS@mail.gmail.com>
	<201011281621.59036.maciej.rutecki@gmail.com>
	<AANLkTi=2O80uDo4DvjVj14Q0DGqTcZMQmnd-q2XV6f4K@mail.gmail.com>
Date: Sun, 28 Nov 2010 22:07:02 +0200
Message-ID: <AANLkTi=jF0hwO8OyquAaT=XFrcCjrdggacCND6jcXFCb@mail.gmail.com>
Subject: Re: 2.6.37-rc3-git4 bad desktop performance
From: Anca Emanuel <anca.emanuel@gmail.com>
To: maciej.rutecki@gmail.com, LKML <linux-kernel@vger.kernel.org>
Cc: Anca Emanuel <anca.emanuel@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Nov 28, 2010 at 6:51 PM, Anca Emanuel <anca.emanuel@gmail.com> wrote:
> On Sun, Nov 28, 2010 at 5:21 PM, Maciej Rutecki
> <maciej.rutecki@gmail.com> wrote:
>> On niedziela, 28 listopada 2010 o 13:21:24 Anca Emanuel wrote:
>>> Linus,
>>>
>>> Last known good kernel: 2.6.37-rc3
>>> Driver: nouveau
>>> Test: play a HD movie.
>>
>> I created a Bugzilla entry at
>> https://bugzilla.kernel.org/show_bug.cgi?id=23912
>> for your bug report, please add your address to the CC list in there, thanks!
>>
>> PS. Please, send config, dmesg, do bisection etc. will be useful...
>
> config and dmesg attached.
> Bisecting now, but it will take some time.
>

Some other strange things: when PC is restarted, I get this image instead:
http://i56.tinypic.com/6eoklw.jpg

In VLC, no other key is responding, but alt+f2
