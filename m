Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751829Ab1BZX2p (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Feb 2011 18:28:45 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:56133 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751204Ab1BZX2n (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Feb 2011 18:28:43 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=eTvdy/PujEdR61RTk6QNm2LcLaUy/B+ySqW9y1OJhjKDeGUH+LRS3vZmZwO+Zx2VPw
         +CsdrN7ud/jIuQENf2ca+l2huuN9/jI5lEX5v0BP6l2PNOjbcA2POOpku6FemOansTSQ
         sfpXUCRp/JOOmzONSZ+qL8JLvyZGGIxT/u5cc=
MIME-Version: 1.0
In-Reply-To: <AANLkTi=+AU3gJJOov8R1fNcZVE7iNpbTLDuMB5PHUk8s@mail.gmail.com>
References: <4D671556.80607@suse.com>
	<20110225060706.GA12723@merkur.ravnborg.org>
	<AANLkTimFd+KFKgiOF8iVoM8Pk77Zy+5CsFs5BCYqCw=L@mail.gmail.com>
	<20110226221838.GA24028@merkur.ravnborg.org>
	<AANLkTi=+AU3gJJOov8R1fNcZVE7iNpbTLDuMB5PHUk8s@mail.gmail.com>
Date: Sat, 26 Feb 2011 18:28:43 -0500
Message-ID: <AANLkTikigj1rDHrUaySHAYrW=GPPezbmcaDfx78AqE1_@mail.gmail.com>
Subject: Re: [PATCH] Add ``cloneconfig'' target
From: Arnaud Lacombe <lacombar@gmail.com>
To: Sam Ravnborg <sam@ravnborg.org>
Cc: Jeff Mahoney <jeffm@suse.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Roman Zippel <zippel@linux-m68k.org>, linux-kbuild@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Sat, Feb 26, 2011 at 6:03 PM, Arnaud Lacombe <lacombar@gmail.com> wrote:
>> The fact that the configuration is gzipped does not warrant
>> a new option to deal with this that almost duplicate the
>> existing functionality.
>>
> agree.
>
Let me precise, as there may be confusion. I agree about the new
target issue, but definitively think this kconfig "option" (more a
hack, which required a special option within kconfig) should be
handled by Kbuild, not Kconfig, ie. I'd discard "option
defconfig_list". File decompression (and eventually which config to
pick) should be done prior to the invocation of Kconfig.

 - Arnaud
