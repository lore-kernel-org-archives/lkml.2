Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755558Ab2DQLZk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Apr 2012 07:25:40 -0400
Received: from mail-lpp01m010-f46.google.com ([209.85.215.46]:35747 "EHLO
	mail-lpp01m010-f46.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754551Ab2DQLZj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Apr 2012 07:25:39 -0400
Message-ID: <4F8D532E.4000305@gmail.com>
Date: Tue, 17 Apr 2012 13:25:34 +0200
From: Kristoffer Eriksson <kristoffer.ericson@gmail.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.7; rv:11.0) Gecko/20120327 Thunderbird/11.0.1
MIME-Version: 1.0
To: =?ISO-8859-1?Q?H=E5var_N=F8vik?= <havar.novik@gmail.com>
CC: alan@linux.intel.com, linux-kernel@vger.kernel.org,
        dri-devel@lists.freedesktop.org
Subject: Re: Bug reports on the psb-gfx driver
References: <CAJqTQGEe6rGw4_f-7o2DUZs1J9a=pACuX4KYkLfA0_McMC2Ukg@mail.gmail.com>
In-Reply-To: <CAJqTQGEe6rGw4_f-7o2DUZs1J9a=pACuX4KYkLfA0_McMC2Ukg@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Håvar Nøvik skrev 2012-04-17 12:53:
> Hi,
>
Greetings,
> I'm experiencing a bug with the driver after a kernel upgrade (3.2 -> 
> 3.3). Every once in a while the screen is blacking out for a second or 
> two.
>
> Anyways, I was wondering where I could look at bug reports or report a 
> new one if I can't find a similar?
>
Ive done a fresh build and Im seeing that same issue that you are 
describing. In a frequency of about 5-15mins it blackens and then returns
within 1-2 seconds. Could you give us a dmesg output? I will do some 
bugtracking once I get back to my laptop.
Alan, any thoughts?

PS: Thanks for the great work on a GMA 500 driver!
>
Alan is the one to thank. :)
> ----
> Regards Håvar Nøvik

