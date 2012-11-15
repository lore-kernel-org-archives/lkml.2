Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751295Ab2KOWFb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Nov 2012 17:05:31 -0500
Received: from perches-mx.perches.com ([206.117.179.246]:32891 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750811Ab2KOWFa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Nov 2012 17:05:30 -0500
Message-ID: <1353017130.20648.16.camel@joe-AO722>
Subject: Re: [ 01/82] Bluetooth: Always compile SCO and L2CAP in Bluetooth
 Core
From: Joe Perches <joe@perches.com>
To: Gustavo Padovan <gustavo@padovan.org>
Cc: linux-kernel@vger.kernel.org
Date: Thu, 15 Nov 2012 14:05:30 -0800
In-Reply-To: <20121115210437.GA3358@joana>
References: <20121114.163044.2287972932330697472.davem@davemloft.net>
	 <20121114213819.GT13292@decadent.org.uk>
	 <1353009872.4867.68.camel@deadeye.wl.decadent.org.uk>
	 <20121115.151341.694285418420091290.davem@davemloft.net>
	 <20121115210437.GA3358@joana>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.6.0-0ubuntu3 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2012-11-15 at 19:04 -0200, Gustavo Padovan wrote:
> if one
> wants use bluetooth on linux he/she needs HCI core, L2CAP and SCO. Those were
> three different modules in the past, but at some point we concluded it does not
> makes sense to have the split.

You could remove the unused CONFIG_ remnants

$ git grep CONFIG_BT_L2CAP
(unused but for defconfigs)

$ git grep CONFIG_BT_SCO
(unused but for defconfigs)


