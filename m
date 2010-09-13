Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753284Ab0IMNLK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Sep 2010 09:11:10 -0400
Received: from mail-yw0-f46.google.com ([209.85.213.46]:52323 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751116Ab0IMNLI convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Sep 2010 09:11:08 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=iA/fV3ZsMwODXgLhy9o6viXv1Fl9/bw25FdvBfJg6NV2fCyySC+yV1hH57A9yLlQag
         4CrAi1Spqtjjd4f+deZ0Shic/3ZNA4KPgsvA3SaxBMbWc2mufnFhgQ5p8qNW1dN15AvL
         6CfK1BMEGyxxi554uG2Cz7AoctBOE+aT5ukBI=
MIME-Version: 1.0
In-Reply-To: <20100913125140.GH30787@n2100.arm.linux.org.uk>
References: <AANLkTi=tWwaFHB0DY=j0UaqbYdYJpGJpmWdGC4aMufSw@mail.gmail.com>
	<4C8E1417.4060204@compulab.co.il>
	<20100913124049.GG30787@n2100.arm.linux.org.uk>
	<AANLkTi=dT1uMrRctB4=Hvh35zVc-DtReWmHj-18cd9XT@mail.gmail.com>
	<20100913125140.GH30787@n2100.arm.linux.org.uk>
Date: Mon, 13 Sep 2010 15:11:07 +0200
Message-ID: <AANLkTi=XoouQ7RtcfSHiGG5vVUcuYAZtuhfzYqOaa8aW@mail.gmail.com>
Subject: Re: ARM target not boot after remap memory
From: Robin Theunis <robint91@gmail.com>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: linux-kernel@vger.kernel.org, linux-embedded@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I have tested it.

When I compiled the kernel with debug_LL on the and triggered such an
error by changing r1 to
something different. And then I got an error of unsupport machine.


2010/9/13 Russell King - ARM Linux <linux@arm.linux.org.uk>
> On Mon, Sep 13, 2010 at 02:48:18PM +0200, Robin Theunis wrote:
>> Hi Russell,
>>
>> Yes I have tested it. I made a breakpoint at 0x2008000 and viewed that
>> the r1 register and there in I found the correct ID.
>
> Ensure that CONFIG_DEBUG_LL is enabled, and that it outputs to the correct
> UART.  The kernel will produce some messages via the DEBUG_LL stuff prior
> to entering the __error loop.
>
