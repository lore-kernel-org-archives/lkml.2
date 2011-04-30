Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755391Ab1D3SOu (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Apr 2011 14:14:50 -0400
Received: from out2.smtp.messagingengine.com ([66.111.4.26]:47122 "EHLO
	out2.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751029Ab1D3SOt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Apr 2011 14:14:49 -0400
X-Sasl-enc: F//c1+tcLGSHJtyS7nhmQSvGb0SamXBjeJUB9qTuppzq 1304187288
Date: Sat, 30 Apr 2011 15:14:46 -0300
From: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
To: Willy Tarreau <w@1wt.eu>
Cc: Randy Dunlap <rdunlap@xenotime.net>, Greg KH <greg@kroah.com>,
        Nikola Ciprich <nikola.ciprich@linuxbox.cz>,
        seto.hidetoshi@jp.fujitsu.com,
        =?iso-8859-1?Q?Herv=E9?= Commowick <hcommowick@exosec.fr>,
        linux-kernel mlist <linux-kernel@vger.kernel.org>,
        linux-stable mlist <stable@kernel.org>
Subject: Re: [stable] 2.6.32.21 - uptime related crashes?
Message-ID: <20110430181446.GB21084@khazad-dum.debian.net>
References: <20110428082625.GA23293@pcnci.linuxbox.cz>
 <20110428183434.GG30645@1wt.eu>
 <20110429100200.GB23293@pcnci.linuxbox.cz>
 <20110430093605.GA10529@1wt.eu>
 <20110430120205.GA2459@nik-comp.lan>
 <20110430155707.GA22021@kroah.com>
 <20110430090805.354484ad.rdunlap@xenotime.net>
 <20110430164958.GE10529@1wt.eu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110430164958.GE10529@1wt.eu>
X-GPG-Fingerprint: 1024D/1CDB0FE3 5422 5C61 F6B7 06FB 7E04  3738 EE25 DE3F
 1CDB 0FE3
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 30 Apr 2011, Willy Tarreau wrote:
> So that would mean that wrapping jiffies should be unrelated to the
> reported panics. Let's wait for Hidetoshi-san's analysis then.

Err, it actually could be a problem when it wraps twice, OR it could be
related to conditions that didn't happen yet right after boot.

But that's less likely, of course.

-- 
  "One disk to rule them all, One disk to find them. One disk to bring
  them all and in the darkness grind them. In the Land of Redmond
  where the shadows lie." -- The Silicon Valley Tarot
  Henrique Holschuh
