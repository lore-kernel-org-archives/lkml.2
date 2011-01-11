Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932167Ab1AKN5E (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Jan 2011 08:57:04 -0500
Received: from kroah.org ([198.145.64.141]:33027 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754144Ab1AKN5C (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Jan 2011 08:57:02 -0500
Date: Tue, 11 Jan 2011 05:56:55 -0800
From: Greg KH <greg@kroah.com>
To: Yinghai Lu <yinghai@kernel.org>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Jesse Barnes <jbarnes@virtuousgeek.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        linux-usb@vger.kernel.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH -v3 1/4] pci, usb: Make usb handoff func all take base
 remapping
Message-ID: <20110111135655.GA6901@kroah.com>
References: <4D2A1382.7010407@kernel.org>
 <4D2AC6BF.3010907@kernel.org>
 <4D2BA8FE.9090204@kernel.org>
 <4D2BAA75.60001@kernel.org>
 <20110111010714.GB32585@kroah.com>
 <4D2BB048.2050509@kernel.org>
 <1294723290.17779.349.camel@pasglop>
 <4D2BF9F3.5080709@kernel.org>
 <1294731467.17779.352.camel@pasglop>
 <AANLkTika_bZxXO3PKek+BHoYqgYGPBPER-H9KJJXjJzn@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AANLkTika_bZxXO3PKek+BHoYqgYGPBPER-H9KJJXjJzn@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 11, 2011 at 01:21:58AM -0800, Yinghai Lu wrote:
> On Mon, Jan 10, 2011 at 11:37 PM, Benjamin Herrenschmidt
> <benh@kernel.crashing.org> wrote:
> > On Mon, 2011-01-10 at 22:34 -0800, Yinghai Lu wrote:
> >>
> >> system_state does not work.
> >> it only have BOOTING and RUNNING ...
> >> RUNNING is set in init/main.c::init_post().
> >> so early_quirk and pci_quirk all with BOOTING stage...
> >
> > Or we can make msleep() itself safe...
> 
> still think the function pointer is more clean and safe.

I do not.
