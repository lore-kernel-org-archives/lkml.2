Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755215Ab1HXFok (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Aug 2011 01:44:40 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:33325 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751899Ab1HXFoj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Aug 2011 01:44:39 -0400
Subject: Re: b43 crash with fragmented packet
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <1314152883.4573.0.camel@jlt3.sipsolutions.net>
References: <1314152883.4573.0.camel@jlt3.sipsolutions.net>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 24 Aug 2011 07:20:38 +0200
Message-ID: <1314163238.4478.8.camel@edumazet-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le mardi 23 août 2011 à 19:28 -0700, Johannes Berg a écrit :
> Just had a crash in mac80211 with an apparently fragmented packet
> (segfault in ieee80211_rx_h_defragment), I can send the stacktrace but I
> can't make much sense of it -- anyone see something similar?
> 



Send it, preferably to netdev, since its probably more suited ;)



