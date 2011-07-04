Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757826Ab1GDPrs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jul 2011 11:47:48 -0400
Received: from netrider.rowland.org ([192.131.102.5]:41121 "HELO
	netrider.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1756775Ab1GDPrq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jul 2011 11:47:46 -0400
Date: Mon, 4 Jul 2011 11:47:45 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@netrider.rowland.org
To: matthieu castet <castet.matthieu@free.fr>
cc: Linux Kernel list <linux-kernel@vger.kernel.org>,
        <linux-usb@vger.kernel.org>
Subject: Re: [PATCH 1/2] EHCI : introduce a common ehci_setup
In-Reply-To: <20110703230220.4d1e8174@mat-laptop>
Message-ID: <Pine.LNX.4.44L0.1107041146130.12242-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 3 Jul 2011, matthieu castet wrote:

> > Instead of putting this routine in ehci-hcd.c, where it will silently 
> > use up unnecessary codespace on thousands or millions of desktop 
> > systems, why not put it into a new separate source file?  Then the
> > SOC drivers can #include that file.
> Ok if you prefer that.
> But if we allow someday to built more than one
> SOC driver at a time (this will come for distribution doing generic arm
> kernel or case like [1]). How it will work ? 

Good point.

> Also because the function is static, the compiler will remove
> it, if it is not used. So it won't use extra codespace on desktop.

Ah, I hadn't thought of that.  Thanks for pointing it out.  Okay, you 
can add my Acked-by to this patch.

Alan Stern

