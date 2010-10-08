Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759096Ab0JHSjV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Oct 2010 14:39:21 -0400
Received: from mail-pv0-f174.google.com ([74.125.83.174]:56843 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752158Ab0JHSjU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Oct 2010 14:39:20 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:from:date
         :x-google-sender-auth:message-id:subject:to:cc:content-type;
        b=cU8CTp+bLAj4wtXXTNsPAa6pDtqt5ohpiSwzta5i3kNWzqWSnDPb7gT1QP6X7sJu9A
         qTjfhDCqHZpvoNzJeacB+vaYdpHDF4BXwG+vzIRsgdExV/gtXyIje8wKSIxmuo4JWblC
         6Bwt4uaWYMFze6YWpPKTikkjNx6AR4tbyAQ9Q=
MIME-Version: 1.0
In-Reply-To: <1286556328.4153.142.camel@m0nster>
References: <1286476616-3373-1-git-send-email-dwalker@codeaurora.org>
 <20101007215019.17b4a34a@lxorguk.ukuu.org.uk> <1286483766.23836.39.camel@c-dwalke-linux.qualcomm.com>
 <20101007220538.2294a7e4@lxorguk.ukuu.org.uk> <1286484678.23836.49.camel@c-dwalke-linux.qualcomm.com>
 <AANLkTimxUAV1=cSJoZFbYiv8JLT+QT=OLEXynxaUtfOS@mail.gmail.com>
 <1286486094.23836.59.camel@c-dwalke-linux.qualcomm.com> <20101008091331.74871a42@lxorguk.ukuu.org.uk>
 <1286551434.4153.21.camel@m0nster> <20101008175636.766dd1f5@lxorguk.ukuu.org.uk>
 <1286556328.4153.142.camel@m0nster>
From: Mike Frysinger <vapier@gentoo.org>
Date: Fri, 8 Oct 2010 14:38:59 -0400
X-Google-Sender-Auth: MAXaTT2TTgccbv3WGaGX-w9Ctpc
Message-ID: <AANLkTikc8X0nz1cCxgfbaqLzCMiBLogLeU0ZdFoGEpP6@mail.gmail.com>
Subject: Re: [PATCH] serial: DCC(JTAG) serial and console emulation support
To: Daniel Walker <dwalker@codeaurora.org>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, linux-kernel@vger.kernel.org,
        "Hyok S. Choi" <hyok.choi@samsung.com>,
        Tony Lindgren <tony@atomide.com>, Jeff Ohlstein <johlstei@quicinc.com>,
        Greg Kroah-Hartman <gregkh@suse.de>, Ben Dooks <ben-linux@fluff.org>,
        Alan Cox <alan@linux.intel.com>, Kukjin Kim <kgene.kim@samsung.com>,
        Feng Tang <feng.tang@intel.com>, Tobias Klauser <tklauser@distanz.ch>,
        Jason Wessel <jason.wessel@windriver.com>,
        Philippe Langlais <philippe.langlais@stericsson.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 8, 2010 at 12:45, Daniel Walker wrote:
> On Fri, 2010-10-08 at 17:56 +0100, Alan Cox wrote:
>> > I don't think the kernel is going to implode if we allow an optional
>> > ttyS override for debugging purposes.. I just don't see that "screwing"
>> > up the kernel.
>>
>> That is perhaps why you are not a subsystem maintainer.
>
> No, I'm sure it's not.
>
> What I was telling Greg is that this type of override is allowed right
> now, if you mod the source (everything is allowed if you mod the source
> right?) ..

just because someone can mod the source code to add a root shell
doesnt mean we should accept patches to do it
-mike
