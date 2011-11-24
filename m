Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752272Ab1KXFwf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Nov 2011 00:52:35 -0500
Received: from mx1.redhat.com ([209.132.183.28]:26022 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750736Ab1KXFwe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Nov 2011 00:52:34 -0500
Message-ID: <4ECDDB86.5000208@redhat.com>
Date: Thu, 24 Nov 2011 13:52:06 +0800
From: Cong Wang <amwang@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.24) Gecko/20111108 Fedora/3.1.16-1.fc14 Thunderbird/3.1.16
MIME-Version: 1.0
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
CC: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        Pekka Enberg <penberg@kernel.org>, Christoph Hellwig <hch@lst.de>,
        Hugh Dickins <hughd@google.com>, Dave Hansen <dave@linux.vnet.ibm.com>,
        Lennart Poettering <lennart@poettering.net>,
        Kay Sievers <kay.sievers@vrfy.org>, linux-mm@kvack.org
Subject: Re: [V3 PATCH 1/2] tmpfs: add fallocate support
References: <1322038412-29013-1-git-send-email-amwang@redhat.com>	<20111124105245.b252c65f.kamezawa.hiroyu@jp.fujitsu.com>	<CAHGf_=oD0Coc=k5kAAQoP=GqK+nc0jd3qq3TmLZaitSjH-ZPmQ@mail.gmail.com>	<20111124120126.9361b2c9.kamezawa.hiroyu@jp.fujitsu.com>	<4ECDB87A.90106@redhat.com> <20111124132349.ca862c9e.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20111124132349.ca862c9e.kamezawa.hiroyu@jp.fujitsu.com>
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

于 2011年11月24日 12:23, KAMEZAWA Hiroyuki 写道:
> 
> thank you for checking. So, at failure path, original data should not be
> cleared, either.
> 

Yes, sure, I will fix that.
