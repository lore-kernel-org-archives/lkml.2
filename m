Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752055Ab0HVJH4 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Aug 2010 05:07:56 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:43632 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751855Ab0HVJHy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Aug 2010 05:07:54 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=SGohHYb5eV4XbvfM/I4skXxYbwM0UPqvTDF32I0ErUn5N9hdDQSukTCHNX9af+AEbV
         9ED7X/i8XTamMibsrSRLa2kE26zfUDlC+dzqhRJ45+noYQ0KZu5aAu3+h0AKPWInB+aq
         7yO+UrRMS4ajr6XH23/erYco53G3R6udbsTCw=
MIME-Version: 1.0
In-Reply-To: <alpine.DEB.2.00.1007221507180.16657@asgard.lang.hm>
References: <20100609183449.110905403@vyatta.com>
	<alpine.LFD.2.00.1006091144120.4506@i5.linux-foundation.org>
	<20100609115403.75ebb6cb@nehalam>
	<alpine.LFD.2.00.1006091203190.4506@i5.linux-foundation.org>
	<20100611103223.799d3ce0@nehalam>
	<20100721195547.GA3448@amt.cnet>
	<AANLkTinffggNzVWn0sZ78wF3nwbEehoEuiVdxUP8MoE4@mail.gmail.com>
	<alpine.DEB.2.00.1007221507180.16657@asgard.lang.hm>
Date: Sun, 22 Aug 2010 17:07:49 +0800
Message-ID: <AANLkTimtrz7JANcaR5mxV1C7HhsyZBLMqifVMw632FTL@mail.gmail.com>
Subject: Re: [RFC] floppy: use single threaded workqueue
From: Amos Kong <kongjianjun@gmail.com>
To: david@lang.hm
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        Stephen Hemminger <shemminger@vyatta.com>,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 23, 2010 at 6:22 AM,  <david@lang.hm> wrote:
> I don't use floopies much anymore, but I've got a fair number of machines
> around that have floppy drives (purchased across about 6 years with from a
> couple vendors and a variety of motherboards)
>
> If someone can go to the effort of documenting what testing you want done I
> may be able to do it.
>
> I would be installing new builds onto the machines to test them, so you can
> do testing that locks up the boxes without impacting anything.
>
> the easier it is to do the tests, the more machines I can test on (bootable
> CD images that I could just pop in and then check the screen later would be
> ideal ;-)
>
> these systems will not have network access.
>
> David Lang


Hello Davide,

Any feedback of testing this patch on real hardware with Linus' methods ?
Thanks.

Amos
