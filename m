Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756228Ab2FYTjf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jun 2012 15:39:35 -0400
Received: from violet.fr.zoreil.com ([92.243.8.30]:56944 "EHLO
	violet.fr.zoreil.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754151Ab2FYTje (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jun 2012 15:39:34 -0400
Date: Mon, 25 Jun 2012 21:28:39 +0200
From: Francois Romieu <romieu@fr.zoreil.com>
To: Johannes Stezenbach <js@sig21.net>
Cc: Thomas Gleixner <tglx@linutronix.de>, Dave Jones <davej@redhat.com>,
        Marc Dionne <marc.c.dionne@gmail.com>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        David Miller <davem@davemloft.net>
Subject: Re: NOHZ: local_softirq_pending 08
Message-ID: <20120625192839.GA20195@electric-eye.fr.zoreil.com>
References: <20120606014656.GA24870@redhat.com> <20120606054251.GA24467@electric-eye.fr.zoreil.com> <20120608023420.GD7191@redhat.com> <alpine.LFD.2.02.1206080954440.3086@ionos> <20120608142333.GB1711@redhat.com> <alpine.LFD.2.02.1206081641040.3086@ionos> <20120608202701.GA26175@electric-eye.fr.zoreil.com> <alpine.LFD.2.02.1206082238120.3086@ionos> <20120608215328.GB26175@electric-eye.fr.zoreil.com> <20120625123809.GA12623@sig21.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120625123809.GA12623@sig21.net>
User-Agent: Mutt/1.4.2.2i
X-Organisation: Land of Sunshine Inc.
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Johannes Stezenbach <js@sig21.net> :
[7dbb491878a2c51d372a8890fa45a8ff80358af1]
> I just upgraded my rarely-used Atom based netbook from 3.3.5 to 3.4.4
> and got the "NOHZ: local_softirq_pending 08" message.
> Should this patch go into stable?

It should not change your life. I'll be fine with whatever policy davej,
tglx or davem see fit (assuming they share one :o) ).

-- 
Ueimor
