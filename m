Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753721Ab0C3O7J (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Mar 2010 10:59:09 -0400
Received: from are.twiddle.net ([75.149.56.221]:41902 "EHLO are.twiddle.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752860Ab0C3O7H (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Mar 2010 10:59:07 -0400
Message-ID: <4BB211B6.2060300@twiddle.net>
Date: Tue, 30 Mar 2010 07:59:02 -0700
From: Richard Henderson <rth@twiddle.net>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.8) Gecko/20100301 Fedora/3.0.3-1.fc12 Thunderbird/3.0.3
MIME-Version: 1.0
To: Matt Turner <mattst88@gmail.com>
CC: linux-alpha@vger.kernel.org, linux-kernel@vger.kernel.org,
       Ivan Kokshaysky <ink@jurassic.park.msu.ru>, ang@brigante.org
Subject: Re: [RFC] alpha: hack objstrip.c to make it compile.
References: <1269913795-1852-1-git-send-email-mattst88@gmail.com>	 <4BB20AAB.7000909@twiddle.net> <b4198de61003300749s7344f4f7o9070fafb142eb5b4@mail.gmail.com>
In-Reply-To: <b4198de61003300749s7344f4f7o9070fafb142eb5b4@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/30/2010 07:49 AM, Matt Turner wrote:
> The problem is that, at least with my distribution, probably others
> too, the headers installed into /usr/include/linux/ are stripped of
> anything inside #ifdef __KERNEL__.

I thought this was built with kernel header files?  It used to be.

If it's built with system header files now, you might as well convert
the thing to use <elf.h> instead.  Which shouldn't be too much different
from what you've done already.  Although I wouldn't bother with the
#defines... just propagate the name changes into the source proper.


r~
