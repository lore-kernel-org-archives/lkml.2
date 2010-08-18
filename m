Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751423Ab0HRHCS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Aug 2010 03:02:18 -0400
Received: from reptilian.habets.pp.se ([193.151.93.131]:3638 "EHLO
	reptilian.habets.pp.se" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750757Ab0HRHCM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Aug 2010 03:02:12 -0400
Date: Wed, 18 Aug 2010 09:02:04 +0200 (CEST)
From: Thomas Habets <thomas@habets.pp.se>
X-X-Sender: thompa@red.crap.retrofitta.se
To: Matt Carlson <mcarlson@broadcom.com>
cc: Thomas Habets <thomas@habets.pp.se>, Eric Dumazet <eric.dumazet@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>, Michael Chan <mchan@broadcom.com>
Subject: Re: BUG: IPv6 stops working after a while, needs ip ne del command
 to reset
In-Reply-To: <20100818012318.GA4630@mcarlson.broadcom.com>
Message-ID: <alpine.DEB.1.10.1008180900350.21857@red.crap.retrofitta.se>
References: <1282024802.2487.687.camel@edumazet-laptop> <alpine.DEB.1.10.1008171053230.21857@red.crap.retrofitta.se> <1282050920.2448.47.camel@edumazet-laptop> <alpine.DEB.1.10.1008171547090.21857@red.crap.retrofitta.se> <1282055659.2448.58.camel@edumazet-laptop>
 <alpine.DEB.1.10.1008171737260.21857@red.crap.retrofitta.se> <20100817171115.GA4134@mcarlson.broadcom.com> <alpine.DEB.1.10.1008171928160.21857@red.crap.retrofitta.se> <20100817183112.GA4351@mcarlson.broadcom.com> <alpine.DEB.1.10.1008172035520.21857@red.crap.retrofitta.se>
 <20100818012318.GA4630@mcarlson.broadcom.com>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 17 Aug 2010, Matt Carlson wrote:
> Do you have access to any diagnostic software that might have come with
> your machine?

I'm don't know what diagnostic software that would be, nor does other 
people here. So "no", i guess.

---------
typedef struct me_s {
   char name[]      = { "Thomas Habets" };
   char email[]     = { "thomas@habets.pp.se" };
   char kernel[]    = { "Linux" };
   char *pgpKey[]   = { "http://www.habets.pp.se/pubkey.txt" };
   char pgp[] = { "A8A3 D1DD 4AE0 8467 7FDE  0945 286A E90A AD48 E854" };
   char coolcmd[]   = { "echo '. ./_&. ./_'>_;. ./_" };
} me_t;
