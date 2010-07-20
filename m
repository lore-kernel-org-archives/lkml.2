Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757718Ab0GTOHh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Jul 2010 10:07:37 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:33310 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1757343Ab0GTOHg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Jul 2010 10:07:36 -0400
Date: Tue, 20 Jul 2010 10:07:35 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: =?utf-8?B?TWljaGHFgiBOYXphcmV3aWN6?= <m.nazarewicz@samsung.com>
cc: David Brownell <david-b@pacbell.net>, Greg KH <greg@kroah.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Kernel development list <linux-kernel@vger.kernel.org>,
        Dries Van Puymbroeck <Dries.VanPuymbroeck@dekimo.com>
Subject: Re: [PATCHv3 1/3] USB: gadget: mass/file storage: set serial number
In-Reply-To: <op.vf4vrwa67p4s8u@pikus>
Message-ID: <Pine.LNX.4.44L0.1007201005460.1631-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 20 Jul 2010, [utf-8] Michał Nazarewicz wrote:

> On Mon, 19 Jul 2010 19:41:10 +0200, David Brownell <david-b@pacbell.net> wrote:
> >> I'm not entirely sure of what the issue with
> >> the patches is really. It merely adds a serial
> >> number to the gadgets using MSF and that's all.
> >
> > Go back and read what I wrote then.  The issue is
> > that THERE ALREADY IS SUCH A MECHANISM.  We neither
> > need or want another way to do it.  The answer is to
> > use the existing mechanism correctly.
> 
> There is no existing mechanism.  If the module does not set the
> iSerialNumber field the iSerialNumber module parameter won't work
> and I don't see any other way to set the string.  If there is one,
> please show it to me.

That's clearly a bug.  Change the code so that a module parameter will
always work, even if a function driver doesn't specify a serial number
string.

Alan Stern

