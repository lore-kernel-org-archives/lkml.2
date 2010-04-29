Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758029Ab0D3QyY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Apr 2010 12:54:24 -0400
Received: from mail-pv0-f174.google.com ([74.125.83.174]:37298 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757630Ab0D3QyR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Apr 2010 12:54:17 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=KMZeVfbTqITc0s+xcp/IIk1oJYfwDn7fVD8FjikFE4rZMUbi2mZ6LJJeoHdw20qdrc
         uolLWArh4LcDxM8VhAq4tUxmg8pooPkTu4V5dPAdG+HyATbV/AYTM5h0W+Iq4stFM6eV
         D36Q9dMwrZMU9XhJHKIhsixap+9cxpxQAx1kQ=
Message-ID: <4BD9866E.4050101@gmail.com>
Date: Thu, 29 Apr 2010 23:15:26 +1000
From: Graeme Russ <graeme.russ@gmail.com>
User-Agent: Thunderbird 2.0.0.24 (X11/20100411)
MIME-Version: 1.0
To: LKML <linux-kernel@vger.kernel.org>
CC: Mike Rapoport <mike@compulab.co.il>,
       Alexander Clouter <alex@digriz.org.uk>
Subject: Re: Request For Help - Embedded x86, Kernel 2.6.33 boots, Mounts
 	JFFS2 rootfs, Stops at init
References: <4BD8415C.9060409@gmail.com> <s91ma7-76h.ln1@chipmunk.wormnet.eu> <y2zd66caabb1004281614qe5af7fa7i6d9d5ac957ea6520@mail.gmail.com>
In-Reply-To: <y2zd66caabb1004281614qe5af7fa7i6d9d5ac957ea6520@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Graeme Russ wrote:
> On Thu, Apr 29, 2010 at 1:37 AM, Alexander Clouter <alex@digriz.org.uk> wrote:
>> Graeme Russ <graeme.russ@gmail.com> wrote:
>>> I've been working for a while now getting the x86 U-Boot port up to speed
>>> to boot a linux kernel
>>>
>> ...ewww x86.
> 
>>>
>> What does you /dev directory look like?  You need to have at least the
>> following:
>> ----
>> mknod console c 5 1
>> mknod null c 1 3
>> mknod ttyS0 c 4 64
>> ----
>>
> 
> tick, tick, tick
> 

Success!!!

I feel _really_ stupid about the cause of the problem.... I hadn't set up
the interrupt mapping of the serial ports in my board initialisation
routines in U-Boot. Once I mapped IRQ4 to UART0 it all sprang to life ;)

Big thanks to everyone for helping and a big thanks to all the linux and
GNU developers for creating such a wonderful 'toy' ;)

Graeme
