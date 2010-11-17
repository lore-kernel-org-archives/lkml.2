Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934263Ab0KQNau (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Nov 2010 08:30:50 -0500
Received: from bof-2.saar.de ([192.109.53.146]:49284 "EHLO oknodo.bof.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932615Ab0KQNat convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Nov 2010 08:30:49 -0500
Subject: Re: 2.6.37-rc2 regression: usb network hotplug
From: Patrick Schaaf <netdev@bof.de>
To: Eric Dumazet <eric.dumazet@gmail.com>
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <1289999117.2687.26.camel@edumazet-laptop>
References: <1289995848.5034.5.camel@lat1>
	 <1289999117.2687.26.camel@edumazet-laptop>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 17 Nov 2010 14:30:45 +0100
Message-ID: <1290000645.5234.1.camel@lat1>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.1.2 
Content-Transfer-Encoding: 8BIT
X-Spam_score: -4.4
X-Spam_score_int: -43
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2010-11-17 at 14:05 +0100, Eric Dumazet wrote:
> Le mercredi 17 novembre 2010 à 13:10 +0100, Patrick Schaaf a écrit :

> > Under 2.6.37-rc2, the first plugging works, the device is reachable as
> > desired, but after unplugging it the first time, I receive the following
> > message every 10 seconds:
> > 
> >  kernel:[  149.632104] unregister_netdevice: waiting for usb0 to become
> > free. Usage count = 1

> Please try
> http://patchwork.ozlabs.org/patch/71354/

Problem solved! Great turnaround :)

thanks
  Patrick

