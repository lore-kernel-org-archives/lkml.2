Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932287Ab1D2H46 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Apr 2011 03:56:58 -0400
Received: from mx4.wp.pl ([212.77.101.8]:22880 "EHLO mx4.wp.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754668Ab1D2H44 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Apr 2011 03:56:56 -0400
Date: Fri, 29 Apr 2011 09:56:54 +0200
From: =?ISO-8859-2?Q?Stanis=B3aw_Gruszka?= <stf_xl@wp.pl>
To: Stanislaw Gruszka <stf_xl@wp.pl>
Cc: Igor Plyatov <plyatov@gmail.com>, Jeff Garzik <jgarzik@pobox.com>,
        linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ATA: pata_at91.c bugfixes
Message-ID: <4dba6f46587df2.89235609@wp.pl>
References: <1303299877-12088-1-git-send-email-plyatov@gmail.com> <20110423093623.GA3410@localhost.localdomain> <4DB6684C.7050505@gmail.com> <20110427183819.GA2285@localhost.localdomain>
In-reply-to: <1303299877-12088-1-git-send-email-plyatov@gmail.com> <20110423093623.GA3410@localhost.localdomain> <4DB6684C.7050505@gmail.com> <20110427183819.GA2285@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Content-Disposition: inline
X-Mailer: Interfejs WWW nowej poczty Wirtualnej Polski
X-User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.9) Gecko/20100827 Red Hat/3.6.9-2.el6 Firefox/3.6.9
Organization: Poznaj Poczte WP http://poczta.wp.pl/info-start.html
X-WP-IP: 209.132.186.34
X-WP-DKIM-Status: good (id: wp.pl)                                      
X-WP-AV: skaner antywirusowy poczty Wirtualnej Polski S. A.
X-WP-SPAM: NO 0000000 [4ZOE]                               
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > * The NCS_RD_CYCLE is equal to the NRD_CYCLE for AT91SAM9, because they
> >   start/finish simultaneously (HW related).
> No, NCS and NRD are different signals, waveforms are different (if 
> configured differently in SMC controller).
Your sentence is true. NRD and NCS cycle time must be the same (otherwise
SMC behaviour is undefined), hence both signals start/finish simultaneously.
Anyway waveforms (setup, and pulse time) can be different. All of thise
are kinda obvious, no? :-)

Stanislaw


