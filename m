Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755872Ab0JKRgE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Oct 2010 13:36:04 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:49725 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755683Ab0JKRgC convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Oct 2010 13:36:02 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=ucC1HP4vJxdsx5jYGqe15p4eD7PV8ik27b205b3ePqNk3Lz4U0gRiEqXc5JxszSkwJ
         4GfJ7Tdjd6ZdIVHWNIYdmmAp23ETlAUVl/bJvC/ozpDYvHAnG+yp1jnm3Gve7lECE5Ck
         a2cpNMS9+X/XAbjXBDS4vdaOq4diVr+mRGro4=
MIME-Version: 1.0
In-Reply-To: <20101006102311.GA5724@cr0.nay.redhat.com>
References: <AANLkTik-RXPfDK12m5OFmLf=gVL1x-h-aDcKX2nz6O3P@mail.gmail.com>
	<20101004101200.GI5189@cr0.nay.redhat.com>
	<AANLkTi=UDned6J0SbcFAfsiF1rg=E-+ZUE2TN=KOg0-f@mail.gmail.com>
	<20101006102311.GA5724@cr0.nay.redhat.com>
Date: Mon, 11 Oct 2010 14:35:59 -0300
Message-ID: <AANLkTimcsWD8bFfVOW0ZqPhrxu3EyvBGELp+A5G=qQYf@mail.gmail.com>
Subject: Re: Information From Buffers
From: Artur Baruchi <mail.baruchi@gmail.com>
To: =?ISO-8859-1?Q?Am=E9rico_Wang?= <xiyou.wangcong@gmail.com>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Americo.

This is fine. I run in my 2.6 kernel machine but didnt work (It works
only for kernel 2.4),  but it is a good starting point.

Thanks!

Att.
Artur Baruchi


On Wed, Oct 6, 2010 at 7:23 AM, Américo Wang <xiyou.wangcong@gmail.com> wrote:
> On Mon, Oct 04, 2010 at 08:04:24AM -0300, Artur Baruchi wrote:
>>Hi Wang.
>>
>>Thanks for your reply.
>>
>>No, inside /proc/meminfo there are just high level information (macro)
>>about what is going on inside the memory. I need do get more details
>>about page cache, things like, what files are being buffered, how much
>>files are being buffered, size of this files, etc. This information
>>can be reach using buffer_head linked list, but I dont know how to
>>walk through this list.
>>
>
>
> I see, seems we can't get this kind of informantion from /proc.
>
> Oracle has a tool for this, check:
>
> http://oss.oracle.com/projects/codefragments/dist/files/pagecache-info/pagecache-info
>
> Hope it can help.
>
> Thanks.
>
