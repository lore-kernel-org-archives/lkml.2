Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753521Ab2LZQs3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Dec 2012 11:48:29 -0500
Received: from netrider.rowland.org ([192.131.102.5]:54863 "HELO
	netrider.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753390Ab2LZQs0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Dec 2012 11:48:26 -0500
Date: Wed, 26 Dec 2012 11:48:25 -0500 (EST)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@netrider.rowland.org
To: Fabio Coatti <fabio.coatti@gmail.com>
cc: linux-kernel@vger.kernel.org, <linux-usb@vger.kernel.org>,
        <rydberg@euromail.se>
Subject: Re: Fwd: usb issues with 3.6.X and 3.7.X
In-Reply-To: <CADpTngXm=zWfBZJAZze6ze9iaDitdqBuy8rz9qDoCCVyLysH9A@mail.gmail.com>
Message-ID: <Pine.LNX.4.44L0.1212261146300.15906-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 26 Dec 2012, Fabio Coatti wrote:

> Hi all,
> I'm experiencing some usb-related issues with recent kernels (3.6.7
> and 3.7.1 at least.)
> Basically I have a V500 epson scanner that worked just fine with older
> kernels; since last time I used it I've changed several kernels and
> now the oldest that I have on my machine is 3.6.7.
> Recently I tried to use the usb scanner without success.

> I've tried to look at usb traffic with usbmon, but honestly it's not
> my ground :)

Can you get an equivalent usbmon trace from an earlier working kernel?
Comparing the two would be useful.

Alan Stern

