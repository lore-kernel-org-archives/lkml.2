Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756425Ab1D3McO (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Apr 2011 08:32:14 -0400
Received: from out2.smtp.messagingengine.com ([66.111.4.26]:57304 "EHLO
	out2.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755454Ab1D3McM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Apr 2011 08:32:12 -0400
X-Sasl-enc: tkqdzoY1d1xiqei4g1mCYz3q/uUiMKGrTaXF5F4OdnQM 1304166731
Date: Sat, 30 Apr 2011 09:32:08 -0300
From: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
To: Willy Tarreau <w@1wt.eu>
Cc: seto.hidetoshi@jp.fujitsu.com,
        =?iso-8859-1?Q?Herv=E9?= Commowick <hcommowick@exosec.fr>,
        linux-kernel mlist <linux-kernel@vger.kernel.org>,
        linux-stable mlist <stable@kernel.org>
Subject: Re: [stable] 2.6.32.21 - uptime related crashes?
Message-ID: <20110430123208.GB16885@khazad-dum.debian.net>
References: <20110428082625.GA23293@pcnci.linuxbox.cz>
 <20110428183434.GG30645@1wt.eu>
 <20110429100200.GB23293@pcnci.linuxbox.cz>
 <20110430093605.GA10529@1wt.eu>
 <20110430112244.GA16885@khazad-dum.debian.net>
 <20110430115422.GC10529@1wt.eu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110430115422.GC10529@1wt.eu>
X-GPG-Fingerprint: 1024D/1CDB0FE3 5422 5C61 F6B7 06FB 7E04  3738 EE25 DE3F
 1CDB 0FE3
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 30 Apr 2011, Willy Tarreau wrote:
> On Sat, Apr 30, 2011 at 08:22:44AM -0300, Henrique de Moraes Holschuh wrote:
> > On Sat, 30 Apr 2011, Willy Tarreau wrote:
> > > There was a kernel parameter in the past that was used to make jiffies wrap
> > > a few minutes after boot, maybe we should revive it to try to reproduce
> > > without waiting 7 new months :-/
> > 
> > IMHO, such an option should be given a permanent home in KCONFIG, and it
> > should be enabled by default.
> 
> Not exactly as it affects uptime.

Well, the offset to the real uptime is known, is there a way to fudge it
back that affects only the uptime reporting?

-- 
  "One disk to rule them all, One disk to find them. One disk to bring
  them all and in the darkness grind them. In the Land of Redmond
  where the shadows lie." -- The Silicon Valley Tarot
  Henrique Holschuh
