Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752850Ab1LLCxY (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Dec 2011 21:53:24 -0500
Received: from mx1.redhat.com ([209.132.183.28]:9507 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752779Ab1LLCxX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Dec 2011 21:53:23 -0500
Message-ID: <4EE56C67.2060909@redhat.com>
Date: Mon, 12 Dec 2011 10:52:23 +0800
From: Cong Wang <amwang@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.24) Gecko/20111108 Fedora/3.1.16-1.fc14 Thunderbird/3.1.16
MIME-Version: 1.0
To: Ralf Baechle <ralf@linux-mips.org>
CC: linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        "David S. Miller" <davem@davemloft.net>, Jiri Kosina <jkosina@suse.cz>,
        Kevin Cernekee <cernekee@gmail.com>,
        "Justin P. Mattock" <justinmattock@gmail.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        David Daney <ddaney@caviumnetworks.com>, linux-mips@linux-mips.org
Subject: Re: [PATCH 04/62] mips: remove the second argument of k[un]map_atomic()
References: <1322371662-26166-1-git-send-email-amwang@redhat.com> <1322371662-26166-5-git-send-email-amwang@redhat.com> <20111209160639.GA30988@linux-mips.org>
In-Reply-To: <20111209160639.GA30988@linux-mips.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

于 2011年12月10日 00:06, Ralf Baechle 写道:
> On Sun, Nov 27, 2011 at 01:26:44PM +0800, Cong Wang wrote:
>
> Acked-by: Ralf Baechle<ralf@linux-mips.org>
>
> I assume you want to merge this patch as part of a single series?
>

I put all the patches into a single tree which is in linux-next now. :)

Thanks for review!
