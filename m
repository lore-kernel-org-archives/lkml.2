Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933121Ab2KNVYg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Nov 2012 16:24:36 -0500
Received: from mail-gg0-f174.google.com ([209.85.161.174]:45038 "EHLO
	mail-gg0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754333Ab2KNVYe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Nov 2012 16:24:34 -0500
Date: Wed, 14 Nov 2012 19:24:26 -0200
From: Gustavo Padovan <gustavo@padovan.org>
To: Ben Hutchings <ben@decadent.org.uk>
Cc: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Ulisses Furquim <ulisses@profusion.mobi>,
        Marcel Holtmann <marcel@holtmann.org>,
        "Gustavo F. Padovan" <padovan@profusion.mobi>
Subject: Re: [ 01/82] Bluetooth: Always compile SCO and L2CAP in Bluetooth
 Core
Message-ID: <20121114212426.GA1866@joana>
Mail-Followup-To: Gustavo Padovan <gustavo@padovan.org>,
	Ben Hutchings <ben@decadent.org.uk>, linux-kernel@vger.kernel.org,
	stable@vger.kernel.org, akpm@linux-foundation.org,
	alan@lxorguk.ukuu.org.uk, Ulisses Furquim <ulisses@profusion.mobi>,
	Marcel Holtmann <marcel@holtmann.org>,
	"Gustavo F. Padovan" <padovan@profusion.mobi>
References: <20121114053933.726869752@decadent.org.uk>
 <20121114053933.935584768@decadent.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121114053933.935584768@decadent.org.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ben,

* Ben Hutchings <ben@decadent.org.uk> [2012-11-14 05:39:34 +0000]:

> 3.2-stable review patch.  If anyone has any objections, please let me know.
> 
> ------------------
> 
> From: Ulisses Furquim <ulisses@profusion.mobi>
> 
> commit f1e91e1640d808d332498a6b09b2bcd01462eff9 upstream.
> 
> The handling of SCO audio links and the L2CAP protocol are essential to
> any system with Bluetooth thus are always compiled in from now on.

I wonder if this could not break any kind of script or code people have that
refer directly to the sco and l2cap modules. Also I don't see this change as
really necessary for 3.2.

	Gustavo
