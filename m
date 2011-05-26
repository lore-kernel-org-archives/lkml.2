Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932626Ab1EZT7X (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 May 2011 15:59:23 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:36197 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758480Ab1EZT7V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 May 2011 15:59:21 -0400
Date: Thu, 26 May 2011 12:59:18 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Dave Young <hidave.darkstar@gmail.com>
Cc: Alexey Dobriyan <adobriyan@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: + sysctl-add-proc_dointvec_unsigned-handler.patch added to -mm
 tree
Message-Id: <20110526125918.ba161d6f.akpm@linux-foundation.org>
In-Reply-To: <AANLkTi=Y32JLeuwagvAsuRg61VHEPQqpReot8ndcajrP@mail.gmail.com>
References: <201103072305.p27N5hKT000474@imap1.linux-foundation.org>
	<20110307232655.GA7234@p183.telecom.by>
	<AANLkTi=-PcbpBjWZuno1fjwZD-tGmC+JMxrzMr1FNwu7@mail.gmail.com>
	<AANLkTikxbAfpHCWzvLscdHccOju=Q1tN0pvcu_=jbeQ_@mail.gmail.com>
	<20110308082409.GA4913@p183.telecom.by>
	<AANLkTik2qpLnxUfD9NyPFSbO5PyYFeRv8cM=Nz1t=UOZ@mail.gmail.com>
	<20110308090247.GA20281@p183.telecom.by>
	<AANLkTi=Y32JLeuwagvAsuRg61VHEPQqpReot8ndcajrP@mail.gmail.com>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


So... where did we end up with this discussion?

There are four patches involved:

http://userweb.kernel.org/~akpm/mmotm/broken-out/sysctl-add-proc_dointvec_bool-handler.patch
http://userweb.kernel.org/~akpm/mmotm/broken-out/sysctl-use-proc_dointvec_bool-where-appropriate.patch
http://userweb.kernel.org/~akpm/mmotm/broken-out/sysctl-add-proc_dointvec_unsigned-handler.patch
http://userweb.kernel.org/~akpm/mmotm/broken-out/sysctl-use-proc_dointvec_unsigned-where-appropriate.patch
