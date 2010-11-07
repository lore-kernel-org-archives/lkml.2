Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752936Ab0KGWIn (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Nov 2010 17:08:43 -0500
Received: from kroah.org ([198.145.64.141]:34442 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752063Ab0KGWIi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Nov 2010 17:08:38 -0500
Date: Sun, 7 Nov 2010 13:59:08 -0800
From: Greg KH <greg@kroah.com>
To: Arnaud Lacombe <lacombar@gmail.com>
Cc: Anca Emanuel <anca.emanuel@gmail.com>, Elvis Dowson <elvis.dowson@mac.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Forked android kernel development from linux kernel mainline
Message-ID: <20101107215908.GA21070@kroah.com>
References: <01784A8B-36A0-4E8A-9729-23C2B19351F8@mac.com> <AANLkTi=UxhRdcDaoKaYVWhPkp_e-uLF4=zhXs7gutkgx@mail.gmail.com> <20101106181202.GA6927@kroah.com> <39580686-A899-4689-BAAD-AF5546B34E49@mac.com> <AANLkTimVsUsrmTvsHqFiqJh1hhryMBemGyW+kYLKGgEu@mail.gmail.com> <20101107155757.GA13736@kroah.com> <AANLkTik=UWwRLOaHMfVifYiQPpSwoYuA6J1EoL5BOgJY@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AANLkTik=UWwRLOaHMfVifYiQPpSwoYuA6J1EoL5BOgJY@mail.gmail.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Nov 07, 2010 at 04:44:48PM -0500, Arnaud Lacombe wrote:
> Hi,
> 
> On Sun, Nov 7, 2010 at 10:57 AM, Greg KH <greg@kroah.com> wrote:
> > [...]
> >
> Just a small comment to say that Android is not the only one (but
> certainly the most visible, and thus easiest to bash on) not making
> effort to get their stuff in mainline. OpenWRT people are also
> maintaining their fork of the kernel, without even using git, and not
> contributing much to mainline (I'm certainly mistaken on that last
> comment).

Isn't the openwrt stuff just drivers and some arch specific code?
Nothing that is core infrastructure, and nothing preventing them from
submitting the drivers and arch code if they want to, right?

If so, why don't you submit it?  Why don't they?

curious,

greg k-h
