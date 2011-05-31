Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758174Ab1EaIL2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 May 2011 04:11:28 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:41247 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756076Ab1EaILY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 May 2011 04:11:24 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Message-ID: <4DE4A2A0.6090704@jp.fujitsu.com>
Date: Tue, 31 May 2011 17:11:12 +0900
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; ja; rv:1.9.2.17) Gecko/20110414 Lightning/1.0b2 Thunderbird/3.1.10
MIME-Version: 1.0
To: caiqian@redhat.com
CC: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        akpm@linux-foundation.org, rientjes@google.com, hughd@google.com,
        kamezawa.hiroyu@jp.fujitsu.com, minchan.kim@gmail.com, oleg@redhat.com
Subject: Re: [PATCH v2 0/5] Fix oom killer doesn't work at all if system have
 > gigabytes memory  (aka CAI founded issue)
References: <348391538.318712.1306828778575.JavaMail.root@zmail06.collab.prod.int.phx2.redhat.com>
In-Reply-To: <348391538.318712.1306828778575.JavaMail.root@zmail06.collab.prod.int.phx2.redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>> Then, I believe your distro applying distro specific patch to ssh.
>> Which distro are you using now?
> It is a Fedora-like distro.

Ho Hm.
Actually, I'm using Fedora14 and I don't see this phenomenon.
I'll try to version up to Fedora15 in near future.

Thanks.

