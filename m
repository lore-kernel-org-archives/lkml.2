Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933656Ab1JDUTZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Oct 2011 16:19:25 -0400
Received: from depni.sinp.msu.ru ([213.131.7.21]:35799 "EHLO depni.sinp.msu.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933567Ab1JDUTY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Oct 2011 16:19:24 -0400
From: Serge Belyshev <belyshev@depni.sinp.msu.ru>
To: Christoph Lameter <cl@gentwo.org>
Cc: Joe Perches <joe@perches.com>, starlight@binnacle.cx,
        Eric Dumazet <eric.dumazet@gmail.com>, linux-kernel@vger.kernel.org,
        netdev <netdev@vger.kernel.org>, Willy Tarreau <w@1wt.eu>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Stephen Hemminger <stephen.hemminger@vyatta.com>
Subject: Re: big picture UDP/IP performance question re 2.6.18  -> 2.6.32
References: <6.2.5.6.2.20111003112108.03a83a28@binnacle.cx>
	<alpine.DEB.2.00.1110041358500.12199@router.home>
	<1317757118.3580.24.camel@Joe-Laptop>
	<alpine.DEB.2.00.1110041442020.15871@router.home>
Date: Tue, 04 Oct 2011 23:49:25 +0400
In-Reply-To: <alpine.DEB.2.00.1110041442020.15871@router.home> (Christoph
	Lameter's message of "Tue, 4 Oct 2011 14:42:28 -0500 (CDT)")
Message-ID: <874nzo35bu.fsf@depni.sinp.msu.ru>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Christoph Lameter <cl@gentwo.org> writes:
> No. BFS has no NUMA support.

BFS has NUMA support since v0.300, 1st oct. 2009.
