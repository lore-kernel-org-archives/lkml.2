Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751807Ab2DVMr1 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Apr 2012 08:47:27 -0400
Received: from netrider.rowland.org ([192.131.102.5]:52930 "HELO
	netrider.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751673Ab2DVMrZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Apr 2012 08:47:25 -0400
Date: Sun, 22 Apr 2012 08:47:24 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@netrider.rowland.org
To: Anil Nair <anilcoll90@gmail.com>
cc: Wang YanQing <Udknight@gmail.com>, Greg KH <greg@kroah.com>,
        lkml <linux-kernel@vger.kernel.org>, <linux-usb@vger.kernel.org>
Subject: Re: [RFC]Is usb port number fixed?
In-Reply-To: <CAHkwNT=DTjdhZmEg+SFGOVi+ZcS-NpHWH8Hh3XV+-BPzHRC7NA@mail.gmail.com>
Message-ID: <Pine.LNX.4.44L0.1204220846290.15283-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 22 Apr 2012, Anil Nair wrote:

> The port number comes from root hub managed by the host controller. Its
> fixed dynamically during enumeration, and can change.
> Please correct me if i am wrong.

You are indeed wrong.  Port numbers are not fixed dynamically and they 
cannot change.

On the other hand, bus numbers _are_ assigned dynamically and they can 
(and do) change.

Alan Stern

