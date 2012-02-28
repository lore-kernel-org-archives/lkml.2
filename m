Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964807Ab2B1Ioj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Feb 2012 03:44:39 -0500
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:52166 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753930Ab2B1Ioh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Feb 2012 03:44:37 -0500
Date: Tue, 28 Feb 2012 08:44:15 +0000
From: Russell King <rmk@arm.linux.org.uk>
To: Mans Rullgard <mans.rullgard@linaro.org>
Cc: Greg KH <gregkh@linuxfoundation.org>, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Javi Merino <javi.merino@arm.com>
Subject: Re: [ 12/72] ARM: 7326/2: PL330: fix null pointer dereference in
	pl330_chan_ctrl()
Message-ID: <20120228084415.GA9280@flint.arm.linux.org.uk>
References: <20120228010511.GA8453@kroah.com> <20120228010430.467184125@linuxfoundation.org> <CAG5Tg6VZR7fmbmxtn=8JXzmDhbJZftryDujtquWfFWJXSEs3LA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAG5Tg6VZR7fmbmxtn=8JXzmDhbJZftryDujtquWfFWJXSEs3LA@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 28, 2012 at 02:29:14AM +0000, Mans Rullgard wrote:
> On 28 February 2012 01:04, Greg KH <gregkh@linuxfoundation.org> wrote:
> > 3.2-stable review patch.  If anyone has any objections, please let me know.
> >
> > ------------------
> >
> > From: Javi Merino <javi.merino@arm.com>
> 
> I'm pretty sure I wrote that patch...

But if you don't submit it, or Javi doesn't include a From: line and
submits it instead, then this is what happens.

-- 
Russell King
 Linux kernel    2.6 ARM Linux   - http://www.arm.linux.org.uk/
 maintainer of:
