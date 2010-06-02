Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758114Ab0FBNPi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jun 2010 09:15:38 -0400
Received: from mail-yw0-f179.google.com ([209.85.211.179]:33716 "EHLO
	mail-yw0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757704Ab0FBNPh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jun 2010 09:15:37 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=Hwsxn6Y/ya0L6isrMlCNZxFzRlDfDYb0Al/SmluItfAaSEzMobFM0SBdUB+KS4BRI5
         rB8WQrVr5T2MsIE8r5APM6k6agwaiBUFLbY/DNMhcipwYVFVirYQ8kpgfGdVkJHiFFDz
         G1idQg5a/urZR0dueE80httt7V6F49TThyZX4=
MIME-Version: 1.0
In-Reply-To: <AANLkTikAhJXiKGzyK7j3V7ev_6f2mn8f-A9tDmgdHy9I@mail.gmail.com>
References: <cover.1275481997.git.mina86@mina86.com>
	<5e151207bced1e418bcfed136a871d2da47e417e.1275481997.git.mina86@mina86.com>
	<e4cb4e647e0ebc51956d6581cd930e3d32f29b99.1275481997.git.mina86@mina86.com>
	<785f09f63fe30ba52ce15fd7cb3f5750aa279ab9.1275481997.git.mina86@mina86.com>
	<5492eaf531c8a59c7c188b9e341572c9cdaed5f2.1275481997.git.mina86@mina86.com>
	<17b54e2cc00a7f730483401f06c79c781491dc62.1275481997.git.mina86@mina86.com>
	<381c3f8318e39caaffa1ecfdf5e3cf13ed59cd27.1275481997.git.mina86@mina86.com>
	<c8725442e3c5b8c7be2cc381ed69a3dc0283ebe1.1275481997.git.mina86@mina86.com>
	<AANLkTikAhJXiKGzyK7j3V7ev_6f2mn8f-A9tDmgdHy9I@mail.gmail.com>
Date: Wed, 2 Jun 2010 21:15:36 +0800
Message-ID: <AANLkTims9AjUwdEbd_UcLEH3a8_MdmVGiNmtsX137D7Z@mail.gmail.com>
Subject: Re: [PATCHv3 07/11] USB: gadget: g_multi: added documentation and INF 
	files
From: Xiaofan Chen <xiaofanc@gmail.com>
To: Michal Nazarewicz <m.nazarewicz@samsung.com>
Cc: linux-usb@vger.kernel.org,
       David Brownell <dbrownell@users.sourceforge.net>,
       Kyungmin Park <kyungmin.park@samsung.com>,
       Marek Szyprowski <m.szyprowski@samsung.com>,
       linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 2, 2010 at 9:02 PM, Xiaofan Chen <xiaofanc@gmail.com> wrote:
> On Wed, Jun 2, 2010 at 8:45 PM, Michal Nazarewicz
> <m.nazarewicz@samsung.com> wrote:
>
>> +**** Improvements in INF files
>> +
>> +It needs to be noted that we are not Windows driver experts and as
>> +such we do not claim that provided INF files are flawless or that they
>> +will work on each and every Windows versions (they were tested on
>> +Windows XP SP3 only).
>> +
>> +The bottom line is, if you can improve the INF files, please do and
>> +share the results[7]. :)
>
> Seems to be very true. I think both INF files are very outdated. But
> I am not familiar with RNDIS to comment on that one.
>

I can see that the INF file for the USB RNDIS still contains the
Win98SE/ME section, not so sure if you want to support them.

For later versions (XP and later), Microsoft has publish the
proper template.
http://msdn.microsoft.com/en-us/library/ff570620.aspx

-- 
Xiaofan http://mcuee.blogspot.com
