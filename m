Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932269Ab2EEA3G (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 May 2012 20:29:06 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:49406 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758581Ab2EEA3E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 May 2012 20:29:04 -0400
Message-ID: <4FA47443.9040505@gmail.com>
Date: Sat, 05 May 2012 10:28:51 +1000
From: Francois Rigaut <frigaut@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:12.0) Gecko/20120430 Thunderbird/12.0.1
MIME-Version: 1.0
To: Greg KH <gregkh@linuxfoundation.org>
CC: linux-pci@vger.kernel.org,
        Nico Schottelius <nico-linux-20120419@schottelius.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: Linux Support for Thunderbolt using Apple Monitor
References: <20120419163800.GB13977@schottelius.org> <CAMVeQ8r_3vuAxzbLyKoecOHOOGijUDkLfw+MK7o-WoWbuOGSrg@mail.gmail.com> <20120502163629.GE928@schottelius.org> <20120502202509.GA26798@kroah.com> <20120503065003.GB13386@schottelius.org> <CAMVeQ8qYu4bShd_+pwRv8bShhusJMDa-jjoqu7EujS4jt7RSNA@mail.gmail.com> <20120503153547.GD20334@kroah.com> <CAMVeQ8q3PMMGmFSgrnqbW2HVdfmN+LgatX3TSfv5_2Ebuuj=QQ@mail.gmail.com> <20120503233858.GA13453@kroah.com> <4FA358ED.1080705@gmail.com> <20120504184851.GB11223@kroah.com>
In-Reply-To: <20120504184851.GB11223@kroah.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 05/05/12 04:48, Greg KH wrote:
> Oh, what exact machine is this? Maybe I can ask around and see if I 
> can dig up one myself, and hey, I always need an excuse to get a new 
> display :) thanks, greg k-h 
The machine is a macbook air 13" mid 2011, with a thunderbolt port 
(physically identical to a mini display port). I hear Linus is using a 
MBA 11", so I don't feel alone here running linux on this thing.
The display is a 27" Apple thunderbolt display. It's a gorgeous display 
with deep colors and lots of dynamics, and not (much) more expensive 
than other 27" display. But it doesn't hot plug (in linux, yet) and the 
only input is through the thunderbolt cable so no luck in using 
alternatives like HDMI (neither VGA, but VGA doesn't support the display 
resolution 2560x1440 anyway).

Good luck,
Francois

