Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752247Ab1JMUYH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Oct 2011 16:24:07 -0400
Received: from mx2.parallels.com ([64.131.90.16]:56025 "EHLO mx2.parallels.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751477Ab1JMUYF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Oct 2011 16:24:05 -0400
Message-ID: <4E9748C5.6070306@parallels.com>
Date: Fri, 14 Oct 2011 00:23:33 +0400
From: Glauber Costa <glommer@parallels.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:7.0) Gecko/20110927 Thunderbird/7.0
MIME-Version: 1.0
To: David Miller <davem@davemloft.net>
CC: <linux-kernel@vger.kernel.org>, <akpm@linux-foundation.org>,
        <lizf@cn.fujitsu.com>, <kamezawa.hiroyu@jp.fujitsu.com>,
        <ebiederm@xmission.com>, <paul@paulmenage.org>, <gthelen@google.com>,
        <netdev@vger.kernel.org>, <linux-mm@kvack.org>, <kirill@shutemov.name>,
        <avagin@parallels.com>, <devel@openvz.org>
Subject: Re: [PATCH v7 0/8] Request for inclusion: tcp memory buffers
References: <1318511382-31051-1-git-send-email-glommer@parallels.com> <20111013.160031.605700447623532119.davem@davemloft.net> <4E9744A6.5010101@parallels.com> <20111013.161608.1413756673453885746.davem@davemloft.net>
In-Reply-To: <20111013.161608.1413756673453885746.davem@davemloft.net>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [195.68.147.2]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/14/2011 12:16 AM, David Miller wrote:
> From: Glauber Costa<glommer@parallels.com>
> Date: Fri, 14 Oct 2011 00:05:58 +0400
>
>> Thank you for letting me now about your view of this that early.
>
> I depend upon my colleagues to assist me in the large task that is reviewing
> the enormous number of networking patches that get submitted.
>
> Unfortunately, none of them got a chance to review this patch set
> seriously, since I know most of them (especially Eric Dumazet) would
> balk at the overhead you're proposing to add to our stack, just as I
> did.
>
> This is the reality of the situation, and I'm sorry to tell you that
> snippy retorts when someone does take the time out to review your work
> won't help at all.
I understand that and appreciate your time.
I'll try to come up with something that addresses this problem in the 
next submission.

