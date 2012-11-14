Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423478Ab2KNVar (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Nov 2012 16:30:47 -0500
Received: from shards.monkeyblade.net ([149.20.54.216]:34921 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1423259Ab2KNVaq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Nov 2012 16:30:46 -0500
Date: Wed, 14 Nov 2012 16:30:44 -0500 (EST)
Message-Id: <20121114.163044.2287972932330697472.davem@davemloft.net>
To: gustavo@padovan.org
Cc: ben@decadent.org.uk, linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        ulisses@profusion.mobi, marcel@holtmann.org, padovan@profusion.mobi
Subject: Re: [ 01/82] Bluetooth: Always compile SCO and L2CAP in Bluetooth
 Core
From: David Miller <davem@davemloft.net>
In-Reply-To: <20121114212426.GA1866@joana>
References: <20121114053933.726869752@decadent.org.uk>
	<20121114053933.935584768@decadent.org.uk>
	<20121114212426.GA1866@joana>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Gustavo Padovan <gustavo@padovan.org>
Date: Wed, 14 Nov 2012 19:24:26 -0200

> Hi Ben,
> 
> * Ben Hutchings <ben@decadent.org.uk> [2012-11-14 05:39:34 +0000]:
> 
>> 3.2-stable review patch.  If anyone has any objections, please let me know.
>> 
>> ------------------
>> 
>> From: Ulisses Furquim <ulisses@profusion.mobi>
>> 
>> commit f1e91e1640d808d332498a6b09b2bcd01462eff9 upstream.
>> 
>> The handling of SCO audio links and the L2CAP protocol are essential to
>> any system with Bluetooth thus are always compiled in from now on.
> 
> I wonder if this could not break any kind of script or code people have that
> refer directly to the sco and l2cap modules. Also I don't see this change as
> really necessary for 3.2.

Agreed, I wish this had not been merged into -stable, I would have never
submitted a patch like this myself.
