Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932532Ab1CRTlQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Mar 2011 15:41:16 -0400
Received: from exchange.solarflare.com ([216.237.3.220]:39657 "EHLO
	exchange.solarflare.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932408Ab1CRTlF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Mar 2011 15:41:05 -0400
Subject: Re: patch for format issues and header bug in net/ipv4/icmp.c
From: Ben Hutchings <bhutchings@solarflare.com>
To: Jeffrin Jose <ahiliation@yahoo.co.in>
Cc: "David S. Miller" <davem@davemloft.net>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org
In-Reply-To: <20110318183529.GA3617@debian.Jeff>
References: <20110318183529.GA3617@debian.Jeff>
Content-Type: text/plain; charset="UTF-8"
Organization: Solarflare Communications
Date: Fri, 18 Mar 2011 19:41:01 +0000
Message-ID: <1300477261.2589.28.camel@bwh-desktop>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.1 (2.32.1-1.fc14) 
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 18 Mar 2011 19:41:04.0700 (UTC) FILETIME=[6B40D7C0:01CBE5A4]
X-TM-AS-Product-Ver: SMEX-8.0.0.1181-6.500.1024-18018.005
X-TM-AS-Result: No--13.552200-0.000000-31
X-TM-AS-User-Approved-Sender: Yes
X-TM-AS-User-Blocked-Sender: No
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2011-03-19 at 00:05 +0530, Jeffrin Jose wrote:
> hello ,
> 
> I have created a patch for net/ipv4/icmp.c
> using checkpatch.pl script to fix several warnings
> and an error.

You need to learn C programming before trying to correct C programs.
You should not just do what it takes to make checkpatch.pl happy.

Ben.

> I have attached the patch along with this mail.
> 
> /Thanks
> 

-- 
Ben Hutchings, Senior Software Engineer, Solarflare
Not speaking for my employer; that's the marketing department's job.
They asked us to note that Solarflare product names are trademarked.

