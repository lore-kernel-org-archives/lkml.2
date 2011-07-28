Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754903Ab1G1BvT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jul 2011 21:51:19 -0400
Received: from serv2.oss.ntt.co.jp ([222.151.198.100]:51558 "EHLO
	serv2.oss.ntt.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754638Ab1G1BvQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jul 2011 21:51:16 -0400
Subject: Re: [PATCH] [59/99] netfilter: IPv6: fix DSCP mangle code
From: Fernando Luis Vazquez Cao <fernando@oss.ntt.co.jp>
To: Andi Kleen <andi@firstfloor.org>
Cc: pablo@netfilter.org, gregkh@suse.de, ak@linux.intel.com,
        linux-kernel@vger.kernel.org, stable@kernel.org, tim.bird@am.sony.com
In-Reply-To: <20110727214858.5FECE2403FF@tassilo.jf.intel.com>
References: <20110727247.325703029@firstfloor.org>
	 <20110727214858.5FECE2403FF@tassilo.jf.intel.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 28 Jul 2011 10:51:13 +0900
Message-ID: <1311817873.2707.5.camel@nausicaa>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Andi,

Thank you for picking up patches 58/99 (netfilter: IPv6: initialize TOS
field in REJECT target module) and 59/99 (netfilter: IPv6: fix DSCP
mangle code).

I would really appreciate it if you could also apply two IGMP snooping
fixes that are already upstream, without them multicast bridging does
not work at all in certain configurations. I will be replying to this
email with the patches.

Thanks,
Fernando

