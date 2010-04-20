Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753346Ab0DTFL2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Apr 2010 01:11:28 -0400
Received: from 1wt.eu ([62.212.114.60]:63436 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751869Ab0DTFL1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Apr 2010 01:11:27 -0400
Date: Tue, 20 Apr 2010 07:11:25 +0200
From: Willy Tarreau <w@1wt.eu>
To: Sylvain Rochet <gradator@gradator.net>
Cc: linux-kernel@vger.kernel.org
Subject: Re: PROBLEM: 2.4.37.9 destroying an Ethernet interface with permanent NUD leaves the kernels with undestroyable interfaces when ATM is compiled in
Message-ID: <20100420051125.GB7798@1wt.eu>
References: <20100407202339.GB4830@gradator.net> <20100408134705.GA983@gradator.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100408134705.GA983@gradator.net>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Sylvain,

indeed, you've hit a real bug. It reminds me of the sad days I
was forced to use IPoA over a USB modem to access the net. The
tiniest config error required a reboot to fix it :-/

Your fix looks right at first glance, but I'll review it deeper
before merging it, though it should be OK since 2.6 is similar.

BTW, is there any reason why you're stuck on 2.4 ? Are you using
some vendor-specific drivers which are not in 2.6, did you not
have the time to upgrade yet, or did you not find a long enable
support for 2.6 releases ? Or anything else ?

I'm asking because whatever keeps users in 2.4 should be addressed
one way or another (probably via some doc to add in 2.4 BTW).

Regards,
Willy

