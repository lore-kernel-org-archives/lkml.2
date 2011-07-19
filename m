Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752475Ab1GSJLV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Jul 2011 05:11:21 -0400
Received: from mx1.redhat.com ([209.132.183.28]:26855 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752210Ab1GSJLU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Jul 2011 05:11:20 -0400
Message-ID: <4E254A24.7060209@redhat.com>
Date: Tue, 19 Jul 2011 17:11:00 +0800
From: Cong Wang <amwang@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.18) Gecko/20110621 Fedora/3.1.11-1.fc14 Thunderbird/3.1.11
MIME-Version: 1.0
To: Eric Dumazet <eric.dumazet@gmail.com>
CC: Mel Gorman <mgorman@suse.de>, linux-kernel@vger.kernel.org,
        akpm@linux-foundation.org, Andi Kleen <andi@firstfloor.org>,
        linux-mm@kvack.org
Subject: Re: [Patch] mm: make CONFIG_NUMA depend on CONFIG_SYSFS
References: <1310987909-3129-1-git-send-email-amwang@redhat.com>	 <20110718135243.GA5349@suse.de>  <4E25221F.6060605@redhat.com>	 <1311058498.16961.15.camel@edumazet-laptop>  <4E252CA1.803@redhat.com> <1311065361.2375.3.camel@edumazet-HP-Compaq-6005-Pro-SFF-PC>
In-Reply-To: <1311065361.2375.3.camel@edumazet-HP-Compaq-6005-Pro-SFF-PC>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

于 2011年07月19日 16:49, Eric Dumazet 写道:
>
> Sorry, I misread the patch, I was confused by the title, since it still
> claims "make CONFIG_NUMA depend on CONFIG_SYSFS" ;)
>

My bad, /me forgot to change $subject. :-/
