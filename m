Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754429Ab1FHAl7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Jun 2011 20:41:59 -0400
Received: from outmail022.snc4.facebook.com ([66.220.144.154]:48780 "EHLO
	mx-out.facebook.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753696Ab1FHAl6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Jun 2011 20:41:58 -0400
Message-ID: <4DEEC579.2080307@fb.com>
Date: Tue, 07 Jun 2011 17:42:33 -0700
From: Arun Sharma <asharma@fb.com>
User-Agent: Mozilla/5.0 (Macintosh; U; Intel Mac OS X 10.6; en-US; rv:1.9.2.17) Gecko/20110414 Thunderbird/3.1.10
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: Mike Frysinger <vapier.adi@gmail.com>, linux-kernel@vger.kernel.org,
        Ingo Molnar <mingo@elte.hu>, David Miller <davem@davemloft.net>,
        Eric Dumazet <eric.dumazet@gmail.com>
Subject: Re: [PATCH 2/2] atomic: move atomic_add_unless to generic code
References: <1306869046-20172-1-git-send-email-asharma@fb.com>	<1306869046-20172-2-git-send-email-asharma@fb.com>	<BANLkTi=Tg=t5LrnvR2Sn08K0Ktm8ZKNCCA@mail.gmail.com>	<4DE55AE9.90505@fb.com>	<BANLkTi=nKqwFKt8boNHQ=imgEz0fdyGCqw@mail.gmail.com>	<4DE7C6FF.70108@fb.com> <20110607164835.86fa15f4.akpm@linux-foundation.org>
In-Reply-To: <20110607164835.86fa15f4.akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 6/7/11 4:48 PM, Andrew Morton wrote:

> This is way too hard.  Please send the *entire* patchset with full
> descriptions in the changelogs.  Not referring to kooky MessageID's, no
> links to archives which might be removed.  Aim to have a complete,
> well-presented patchset which our children can as-easily-as-possible
> understand when they read the git commit logs in 2042.

Andrew: I sent you an updated patch set a few minutes ago. No code 
changes - mostly updated commit log and comments.

  -Arun

