Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754047Ab0LNKhJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Dec 2010 05:37:09 -0500
Received: from mx1.redhat.com ([209.132.183.28]:62622 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751421Ab0LNKhI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Dec 2010 05:37:08 -0500
Message-ID: <4D0748B4.4050109@redhat.com>
Date: Tue, 14 Dec 2010 18:36:36 +0800
From: Cong Wang <amwang@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20101209 Fedora/3.1.7-0.35.b3pre.fc14 Thunderbird/3.1.7
MIME-Version: 1.0
To: "Suzuki K. Poulose" <suzuki@in.ibm.com>
CC: linux-kernel@vger.kernel.org,
        Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>,
        Christoph Hellwig <hch@lst.de>, Masami Hiramatsu <mhiramat@redhat.com>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Daisuke HATAYAMA <d.hatayama@jp.fujitsu.com>,
        Andi Kleen <andi@firstfloor.org>, Roland McGrath <roland@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Oleg Nesterov <oleg@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [Patch 10/21] Create /proc/pid/core entry
References: <20101214152259.67896960@suzukikp> <20101214154104.1a7bc8ae@suzukikp>
In-Reply-To: <20101214154104.1a7bc8ae@suzukikp>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

于 2010年12月14日 18:11, Suzuki K. Poulose 写道:
> Create the /proc/PID/core entry.
>
> Signed-off-by: Suzuki K. Poulose<suzuki@in.ibm.com>
> Signed-off-by: Ananth N.Mavinakayanahalli<ananth@in.ibm.com>

Can we have a new Kconfig for this? Instead of reusing CONFIG_ELF_CORE.
You have to make it depend on CONFIG_FREEZER, I think.

Thanks.
