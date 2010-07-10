Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754869Ab0GJMh1 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Jul 2010 08:37:27 -0400
Received: from router-fw.net-space.pl ([89.174.63.77]:60247 "EHLO
	router-fw.net-space.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754799Ab0GJMh0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Jul 2010 08:37:26 -0400
Date: Sat, 10 Jul 2010 14:36:52 +0200
From: Daniel Kiper <dkiper@net-space.pl>
To: James Harper <james.harper@bendigoit.com.au>
Cc: Daniel Kiper <dkiper@net-space.pl>, Andi Kleen <andi@firstfloor.org>,
       jeremy@goop.org, xen-devel@lists.xensource.com,
       linux-kernel@vger.kernel.org
Subject: Re: [Xen-devel] Re: GSoC 2010 - Migration from memory ballooning tomemory hotplug in Xen
Message-ID: <20100710123652.GA17617@router-fw-old.local.net-space.pl>
References: <20100708194553.GA30124@router-fw-old.local.net-space.pl> <871vbdr4ey.fsf@basil.nowhere.org> <AEC6C66638C05B468B556EA548C1A77D01A0A57D@trantor> <20100709173455.GD8696@router-fw-old.local.net-space.pl> <AEC6C66638C05B468B556EA548C1A77D01A0A5F4@trantor>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AEC6C66638C05B468B556EA548C1A77D01A0A5F4@trantor>
User-Agent: Mutt/1.3.28i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jul 10, 2010 at 03:17:57PM +1000, James Harper wrote:
> > On Fri, Jul 09, 2010 at 08:58:01AM +1000, James Harper wrote:
> > > > While you can do that the value is not very large because you
> > > > could just start the guests with more memory, but ballooned in
> > > > the first place (so that they don't actually use it)
> > >
> > > I think hotplug is a better method for adding memory for Windows.
> >
> > Maybe in the future I write somthing for Windows...
>
> For Windows, I believe you would need to emulate actual hotplug of
> memory like a physical machine, using ACPI. It's only supported on
> Enterprise versions of Windows too.

In 99.9% yes because it is normal way of configuring devices in Windows.
However, to take final decision I must read some docs and do some tests.

Daniel
