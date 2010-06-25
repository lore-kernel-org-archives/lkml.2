Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756683Ab0FYX30 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jun 2010 19:29:26 -0400
Received: from kroah.org ([198.145.64.141]:33346 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750992Ab0FYX3Z (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jun 2010 19:29:25 -0400
Date: Fri, 25 Jun 2010 15:52:25 -0700
From: Greg KH <greg@kroah.com>
To: Pekka Enberg <penberg@cs.helsinki.fi>
Cc: Petri Lehtinen <petri.lehtinen@inoi.fi>,
       Linux Netdev List <netdev@vger.kernel.org>,
       David Miller <davem@davemloft.net>, avorontsov@ru.mvista.com,
       linux-kernel@vger.kernel.org, stable@kernel.org
Subject: Re: [stable] Please apply ucc_geth patches to 2.6.32-stable
Message-ID: <20100625225225.GI10683@kroah.com>
References: <20100609071623.GC20057@colossus>
 <AANLkTin_EvlveCvbCZ0vH54UEP479ufQ-irFqXSOnT0R@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AANLkTin_EvlveCvbCZ0vH54UEP479ufQ-irFqXSOnT0R@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 09, 2010 at 11:02:55AM +0300, Pekka Enberg wrote:
> On Wed, Jun 9, 2010 at 10:16 AM, Petri Lehtinen <petri.lehtinen@inoi.fi> wrote:
> > The following three patches fix some serious flaws in the ucc_geth
> > network driver in 2.6.32. From oldest to newest:
> >
> > 7583605b6d29f1f7f6fc505b883328089f3485ad ucc_geth: Fix empty TX queue processing
> > 08b5e1c91ce95793c59a59529a362a1bcc81faae ucc_geth: Fix netdev watchdog triggering on link changes
> > 34692421bc7d6145ef383b014860f4fde10b7505 ucc_geth: Fix full TX queue processing
> >
> > They apply cleanly on top of 2.6.32-stable master. They were also
> > originally Cc'd to be included in 2.6.32-stable.
> 
> You forgot to CC stable@kernel.org, netdev, and the original author of
> those patches.

Wierd that our script didn't pick these up, sorry about that.  Now
applied.

greg k-h
