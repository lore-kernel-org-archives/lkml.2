Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754896Ab1KPITx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Nov 2011 03:19:53 -0500
Received: from mailhub.sw.ru ([195.214.232.25]:17718 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752967Ab1KPITv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Nov 2011 03:19:51 -0500
Message-ID: <4EC3720B.4000606@parallels.com>
Date: Wed, 16 Nov 2011 12:19:23 +0400
From: Pavel Emelyanov <xemul@parallels.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110428 Fedora/3.1.10-1.fc15 Thunderbird/3.1.10
MIME-Version: 1.0
To: "Serge E. Hallyn" <serge@hallyn.com>
CC: Adrian Reber <adrian@lisas.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Oren Laadan <orenl@cs.columbia.edu>,
        "matt.helsley@gmail.com" <matt.helsley@gmail.com>,
        =?ISO-8859-1?Q?Peter_?= =?ISO-8859-1?Q?V=E4terlein?= 
	<Peter.Vaeterlein@hs-esslingen.de>
Subject: Re: linux-cr ported to 3.2-rc1
References: <20111114151300.GT16442@lisas.de> <4EC131A3.9050504@parallels.com> <20111115182944.GA16212@hallyn.com>
In-Reply-To: <20111115182944.GA16212@hallyn.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>> The chances are ... quite high. We implement our C/R code in the userspace
>> and require very few pieces from kernel. So far 2 out of 3 proposed API
>> extensions were merged into -mm tree.
> 
> Hi Pavel,
> 
> does '2 out of 3 proposed' mean '2 out of 3 needed for full c/r support'?

No, for the c/r of process tree with any types of memory, open files and pipes.
