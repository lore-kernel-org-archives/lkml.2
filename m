Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754019Ab1C1FqZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Mar 2011 01:46:25 -0400
Received: from mx1.redhat.com ([209.132.183.28]:49926 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751001Ab1C1FqY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Mar 2011 01:46:24 -0400
Message-ID: <4D90206E.1090307@redhat.com>
Date: Mon, 28 Mar 2011 13:45:18 +0800
From: Cong Wang <amwang@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.15) Gecko/20110307 Fedora/3.1.9-0.39.b3pre.fc14 Thunderbird/3.1.9
MIME-Version: 1.0
To: Amerigo Wang <amwang@redhat.com>
CC: linux-kernel@vger.kernel.org, WANG Cong <xiyou.wangcong@gmail.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Andrew Morton <akpm@linux-foundation.org>,
        Eric B Munson <emunson@mgebm.net>,
        David Rientjes <rientjes@google.com>,
        Dave Hansen <dave@linux.vnet.ibm.com>, Mel Gorman <mel@csn.ul.ie>,
        linux-fsdevel@vger.kernel.org
Subject: Re: [Patch V2] proc: check error pointer returned by m_start()
References: <AANLkTi=mqKF=xeMYbj9LZgPfSLHSkO1JRXsNTW3LyHqu@mail.gmail.com> <1301289993-24248-1-git-send-email-amwang@redhat.com>
In-Reply-To: <1301289993-24248-1-git-send-email-amwang@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

于 2011年03月28日 13:26, Amerigo Wang 写道:
> From: WANG Cong<xiyou.wangcong@gmail.com>
>
> V2: move the check into m_stop() as suggested by Linus,
> also, most ->show() implementations assume the second parameter 'v'
> is not NULL, this fixes them too.

Linus, forget this one, I saw you already checked in your own
fix, I will make one based on that. :)

Thanks.
