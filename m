Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753361Ab2DWBwN (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Apr 2012 21:52:13 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:62979 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753062Ab2DWBwM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Apr 2012 21:52:12 -0400
Date: Mon, 23 Apr 2012 09:52:12 +0800
From: Wang YanQing <udknight@gmail.com>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Anil Nair <anilcoll90@gmail.com>, Greg KH <greg@kroah.com>,
        lkml <linux-kernel@vger.kernel.org>, linux-usb@vger.kernel.org
Subject: Re: [RFC]Is usb port number fixed?
Message-ID: <20120423015212.GA7547@udknight>
Mail-Followup-To: Wang YanQing <Udknight@gmail.com>,
	Alan Stern <stern@rowland.harvard.edu>,
	Anil Nair <anilcoll90@gmail.com>, Greg KH <greg@kroah.com>,
	lkml <linux-kernel@vger.kernel.org>, linux-usb@vger.kernel.org
References: <CAHkwNT=DTjdhZmEg+SFGOVi+ZcS-NpHWH8Hh3XV+-BPzHRC7NA@mail.gmail.com>
 <Pine.LNX.4.44L0.1204220846290.15283-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.44L0.1204220846290.15283-100000@netrider.rowland.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Apr 22, 2012 at 08:47:24AM -0400, Alan Stern wrote:
> On Sun, 22 Apr 2012, Anil Nair wrote:
> 
> > The port number comes from root hub managed by the host controller. Its
> > fixed dynamically during enumeration, and can change.
> > Please correct me if i am wrong.
> 
> You are indeed wrong.  Port numbers are not fixed dynamically and they 
> cannot change.
Right?
Could you pin out the codes in kernel?
> 
> On the other hand, bus numbers _are_ assigned dynamically and they can 
> (and do) change.
> 
Indeed, I never meat the situation lspci output different bus number on the same machine.
Any more comment?
