Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753692Ab0E1XUJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 May 2010 19:20:09 -0400
Received: from claw.goop.org ([74.207.240.146]:44408 "EHLO claw.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752837Ab0E1XUG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 May 2010 19:20:06 -0400
Message-ID: <4C004FA3.1040004@goop.org>
Date: Fri, 28 May 2010 16:20:03 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100430 Fedora/3.0.4-2.fc12 Lightning/1.0b2pre Thunderbird/3.0.4
MIME-Version: 1.0
To: Bastian Blank <waldi@debian.org>, Michael Tokarev <mjt@tls.msk.ru>,
       xen-devel@lists.xensource.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Fix name of Xen event-channel device
References: <20100526105144.GA28280@wavehammer.waldi.eu.org> <20100527073512.GA17135@wavehammer.waldi.eu.org> <20100527143104.GB6040@wavehammer.waldi.eu.org> <20100527150251.GD6040@wavehammer.waldi.eu.org> <4BFEA2DF.8080006@msgid.tls.msk.ru> <20100527171313.GB11358@wavehammer.waldi.eu.org>
In-Reply-To: <20100527171313.GB11358@wavehammer.waldi.eu.org>
X-Enigmail-Version: 1.0.1
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/27/2010 10:13 AM, Bastian Blank wrote:
> The udev rules will just not longer match, as they only rename the
> device, this is no problem. However libxc _will_ break, as it lacks
> proper error check in its own device creation routine.
>   

Yeah, that's really annoying.  I can't change the kernel without also
having a flag day to update libxc.  I guess we could make sure all the
stable Xen branches get a libxc fix backported to them, but I wonder if
it would break other toolstacks?

> However there are not much possibilities here: this support will go away
> and it will annoy every user for some time.
>   

But if we don't make any kernel changes then libxc will muddle on even
if udev stops handling the device name properly?

    J
