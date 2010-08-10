Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752090Ab0HJF2L (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Aug 2010 01:28:11 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:63686 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751513Ab0HJF2F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Aug 2010 01:28:05 -0400
MIME-Version: 1.0
In-Reply-To: <20100810052146.GC3853@nokia.com>
References: <1275563341-31078-1-git-send-email-felipe.balbi@nokia.com> 
	<20100809103618.GE11340@nokia.com> <AANLkTinA72_YkcyN=1q04CDG5uW8PiOz5+jg9nTN7PuE@mail.gmail.com> 
	<20100810052146.GC3853@nokia.com>
From: Grant Likely <grant.likely@secretlab.ca>
Date: Mon, 9 Aug 2010 23:27:43 -0600
X-Google-Sender-Auth: Y6BH2A_78dI4l6CN5QFv-irzMMs
Message-ID: <AANLkTi=SyCye+dRZXKUF+yeXiXW2qZ5RETxvEYMq+myD@mail.gmail.com>
Subject: Re: [PATCH] spi: omap2_mcspi: make use of dev_vdbg()
To: felipe.balbi@nokia.com
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Linux OMAP Mailing List <linux-omap@vger.kernel.org>,
        Tony Lindgren <tony@atomide.com>,
        "Tereshonkov Roman (Nokia-MS/Helsinki)" <roman.tereshonkov@nokia.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        David Brownell <david-b@pacbell.net>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 9, 2010 at 11:21 PM, Felipe Balbi <felipe.balbi@nokia.com> wrote:
> Hi,
>
> On Mon, Aug 09, 2010 at 03:22:31PM +0200, ext Grant Likely wrote:
>>
>> It didn't get sent to the spi-devel-general list, so it didn't get
>> picked up by patchwork and wasn't there for me to pick up when I was
>> collecting stuff for .36.
>
> that's subscribers only ? I couldn't bother subscribing to a list just to
> send a small cleanup patch. Even though it didn't go to the list, both
> maintainers are in Cc list and nobody even commented.

My inbox gets very full.  If it isn't in patchwork then I tend to lose it.

> Anyways, could you, somehow, get an account on majordomo ?

I know, the sourceforge list is a bit of a pain.  I don't even know
who the admin of that list is.  It was set up before I started the SPI
maintainership.  I've been thinking about creating a new spi list on
vger.kernel.org.

g.
