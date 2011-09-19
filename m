Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756763Ab1ISB0s (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Sep 2011 21:26:48 -0400
Received: from out3.smtp.messagingengine.com ([66.111.4.27]:43599 "EHLO
	out3.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752301Ab1ISB0r (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Sep 2011 21:26:47 -0400
X-Sasl-enc: wr+k5RI96b+Zxo3tM0d2fdyWbCHX1i+bZI4nRu22JV5G 1316395606
Date: Sun, 18 Sep 2011 22:26:42 -0300
From: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
To: Martin Devera <martin.devera@cdi.cz>
Cc: linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: iptables 2.6.38, can kernel erroneously bypass PREROUTING ?
Message-ID: <20110919012642.GB16718@khazad-dum.debian.net>
References: <4E7616F5.7080009@cdi.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4E7616F5.7080009@cdi.cz>
X-GPG-Fingerprint: 1024D/1CDB0FE3 5422 5C61 F6B7 06FB 7E04  3738 EE25 DE3F
 1CDB 0FE3
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(netdev added to cc)

On Sun, 18 Sep 2011, Martin Devera wrote:
> we have problem with high-bw router (1gbit, conntrack, nat, htb qos)
> where after some time (weeks) DNAT stops working.
> I tried to include "-t raw -A PREROUTING -i eth0" an it got ZERO hits
> while -i eth1 has many.
> Thus DNAT (in -t nat) doesn't work but interestingly conntrack (and thus
> SNAT records) is ok - packets from eth0 sems to be routed.
> Only they "somehow" skip all PREROUTING chains.. But from sources
> I can find no way how only eth0 pkts could skip PREROUTING but still
> be routed and contracked ... Anyone has a clue ?
> 
> A didn't more investigation as I had to reboot it - it always helps.

-- 
  "One disk to rule them all, One disk to find them. One disk to bring
  them all and in the darkness grind them. In the Land of Redmond
  where the shadows lie." -- The Silicon Valley Tarot
  Henrique Holschuh
