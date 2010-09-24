Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752493Ab0IXFmw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Sep 2010 01:42:52 -0400
Received: from mail-gy0-f174.google.com ([209.85.160.174]:51337 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751137Ab0IXFmv convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Sep 2010 01:42:51 -0400
MIME-Version: 1.0
In-Reply-To: <20100924053648.GA5453@cr0.nay.redhat.com>
References: <AANLkTinGJmAzdd=HOKZYSh69F6T9HMznOKW5BS90=Q-4@mail.gmail.com>
	<20100924053648.GA5453@cr0.nay.redhat.com>
Date: Fri, 24 Sep 2010 07:42:50 +0200
Message-ID: <AANLkTimDtYF_ZNGvH-UxWrFyMsxjzKfsgyDTJnjt70Hs@mail.gmail.com>
Subject: Re: Long maintenance kernel versions.
From: Geoffrey Said <geoffrey@2x.com>
To: =?ISO-8859-1?Q?Am=E9rico_Wang?= <xiyou.wangcong@gmail.com>
Cc: stable@kernel.org, linux-kernel@vger.kernel.org, greg@kroah.com
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thanks for the prompt reply,

but this puts us at a disadvantage as we will not know which kernel
will be long term supported when starting the development process.

Take our case for the 34 kernel.  I knew that SuSE were going to use
the 34 kernel in their 11.3 and since it was the latest we started
work on the integration.  Now after the work is almost over, we hear
that it will not be maintained anymore and we need to move to 35.  I
do not think that this is a good system for people like us which have
limited resources at their disposal.

Can I suggest that their is a road map and long term maintenance
kernels are ear marked before hand by the major Linux distributions?
This will enable us to wait and integrate kernels fully confident that
they will be long term supported.

Thanks
Geoffrey Said

On Fri, Sep 24, 2010 at 7:36 AM, Américo Wang <xiyou.wangcong@gmail.com> wrote:
> On Fri, Sep 24, 2010 at 07:10:09AM +0200, Geoffrey Said wrote:
>>To whom it may concern.
>>
>>I would like to put forward the following questions.  Hope that I am
>>not making a fool of myself!
>>
>>How is the procedure by which a certain kernel version is declared as
>>a long maintenance version?
>
>
> This mainly depends on how many major Linux distributions rely on
> that version of kernel, AFAIK.
>
>>Is the version decided before or after the release of the stable kernel?
>
> After.
>
>>And where can I check for planned long term maintenance versions?
>>
>
> http://en.wikipedia.org/wiki/Linux_kernel
>
>



-- 
Geoffrey Said
Software Developer
2X Software - http://www.2x.com
Developers of virtual computing software
2X VirtualDesktopServer - 2X ApplicationServer - 2X LoadBalancer - 2X
ThinClientServer

Tel: +356 2258 3800
Fax:+356 2137 7078
