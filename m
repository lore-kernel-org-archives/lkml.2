Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755617Ab1D3Lyu (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Apr 2011 07:54:50 -0400
Received: from 1wt.eu ([62.212.114.60]:35850 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755296Ab1D3Lyu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Apr 2011 07:54:50 -0400
Date: Sat, 30 Apr 2011 13:54:22 +0200
From: Willy Tarreau <w@1wt.eu>
To: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
Cc: seto.hidetoshi@jp.fujitsu.com,
        =?iso-8859-1?Q?Herv=E9?= Commowick <hcommowick@exosec.fr>,
        linux-kernel mlist <linux-kernel@vger.kernel.org>,
        linux-stable mlist <stable@kernel.org>
Subject: Re: [stable] 2.6.32.21 - uptime related crashes?
Message-ID: <20110430115422.GC10529@1wt.eu>
References: <20110428082625.GA23293@pcnci.linuxbox.cz> <20110428183434.GG30645@1wt.eu> <20110429100200.GB23293@pcnci.linuxbox.cz> <20110430093605.GA10529@1wt.eu> <20110430112244.GA16885@khazad-dum.debian.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110430112244.GA16885@khazad-dum.debian.net>
User-Agent: Mutt/1.4.2.3i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Apr 30, 2011 at 08:22:44AM -0300, Henrique de Moraes Holschuh wrote:
> On Sat, 30 Apr 2011, Willy Tarreau wrote:
> > There was a kernel parameter in the past that was used to make jiffies wrap
> > a few minutes after boot, maybe we should revive it to try to reproduce
> > without waiting 7 new months :-/
> 
> IMHO, such an option should be given a permanent home in KCONFIG, and it
> should be enabled by default.

Not exactly as it affects uptime.

Willy

