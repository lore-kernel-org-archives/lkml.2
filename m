Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933131Ab2KNVi0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Nov 2012 16:38:26 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:33498 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753562Ab2KNViY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Nov 2012 16:38:24 -0500
Date: Wed, 14 Nov 2012 21:38:19 +0000
From: Ben Hutchings <ben@decadent.org.uk>
To: David Miller <davem@davemloft.net>
Cc: gustavo@padovan.org, linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        ulisses@profusion.mobi, marcel@holtmann.org, padovan@profusion.mobi
Message-ID: <20121114213819.GT13292@decadent.org.uk>
References: <20121114053933.726869752@decadent.org.uk>
 <20121114053933.935584768@decadent.org.uk>
 <20121114212426.GA1866@joana>
 <20121114.163044.2287972932330697472.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121114.163044.2287972932330697472.davem@davemloft.net>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: ben@decadent.org.uk
Subject: Re: [ 01/82] Bluetooth: Always compile SCO and L2CAP in Bluetooth
 Core
X-SA-Exim-Version: 4.2.1 (built Mon, 22 Mar 2010 06:51:10 +0000)
X-SA-Exim-Scanned: Yes (on shadbolt.decadent.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 14, 2012 at 04:30:44PM -0500, David Miller wrote:
> From: Gustavo Padovan <gustavo@padovan.org>
> Date: Wed, 14 Nov 2012 19:24:26 -0200
> 
> > Hi Ben,
> > 
> > * Ben Hutchings <ben@decadent.org.uk> [2012-11-14 05:39:34 +0000]:
> > 
> >> 3.2-stable review patch.  If anyone has any objections, please let me know.
> >> 
> >> ------------------
> >> 
> >> From: Ulisses Furquim <ulisses@profusion.mobi>
> >> 
> >> commit f1e91e1640d808d332498a6b09b2bcd01462eff9 upstream.
> >> 
> >> The handling of SCO audio links and the L2CAP protocol are essential to
> >> any system with Bluetooth thus are always compiled in from now on.
> > 
> > I wonder if this could not break any kind of script or code people have that
> > refer directly to the sco and l2cap modules. Also I don't see this change as
> > really necessary for 3.2.
> 
> Agreed, I wish this had not been merged into -stable, I would have never
> submitted a patch like this myself.

This is required by:

commit ff03261adc8b4bdd8291f1783c079b53a892b429
Author: Vinicius Costa Gomes <vinicius.gomes@openbossa.org>
Date:   Thu Aug 23 21:32:44 2012 -0300

    Bluetooth: Fix sending a HCI Authorization Request over LE links
    
    commit d8343f125710fb596f7a88cd756679f14f4e77b9 upstream.

which was already applied.

Ben.

-- 
Ben Hutchings
We get into the habit of living before acquiring the habit of thinking.
                                                              - Albert Camus
