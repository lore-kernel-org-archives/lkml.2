Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754935Ab1D3LWt (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Apr 2011 07:22:49 -0400
Received: from out2.smtp.messagingengine.com ([66.111.4.26]:52236 "EHLO
	out2.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754462Ab1D3LWs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Apr 2011 07:22:48 -0400
X-Sasl-enc: ZAcN5kn/VzG5t2ZXDvtOK7UwXzK6rKCAF0MgZ3qtHMOT 1304162567
Date: Sat, 30 Apr 2011 08:22:44 -0300
From: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
To: Willy Tarreau <w@1wt.eu>
Cc: Nikola Ciprich <nikola.ciprich@linuxbox.cz>,
        linux-kernel mlist <linux-kernel@vger.kernel.org>,
        linux-stable mlist <stable@kernel.org>,
        =?iso-8859-1?Q?Herv=E9?= Commowick <hcommowick@exosec.fr>,
        seto.hidetoshi@jp.fujitsu.com
Subject: Re: [stable] 2.6.32.21 - uptime related crashes?
Message-ID: <20110430112244.GA16885@khazad-dum.debian.net>
References: <20110428082625.GA23293@pcnci.linuxbox.cz>
 <20110428183434.GG30645@1wt.eu>
 <20110429100200.GB23293@pcnci.linuxbox.cz>
 <20110430093605.GA10529@1wt.eu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110430093605.GA10529@1wt.eu>
X-GPG-Fingerprint: 1024D/1CDB0FE3 5422 5C61 F6B7 06FB 7E04  3738 EE25 DE3F
 1CDB 0FE3
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 30 Apr 2011, Willy Tarreau wrote:
> There was a kernel parameter in the past that was used to make jiffies wrap
> a few minutes after boot, maybe we should revive it to try to reproduce
> without waiting 7 new months :-/

IMHO, such an option should be given a permanent home in KCONFIG, and it
should be enabled by default.

-- 
  "One disk to rule them all, One disk to find them. One disk to bring
  them all and in the darkness grind them. In the Land of Redmond
  where the shadows lie." -- The Silicon Valley Tarot
  Henrique Holschuh
