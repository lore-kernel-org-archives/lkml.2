Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753728Ab0ECJZq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 May 2010 05:25:46 -0400
Received: from fg-out-1718.google.com ([72.14.220.155]:1169 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753397Ab0ECJZp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 May 2010 05:25:45 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=mJHtq0dM/Mzd9shsBnro/VUlXWSfnpiI2ZvS/ngnYf/zGktob6EAb8Ppb7/a7j9eXB
         84g1UOgX5HjYWiKlgYZDpApg6aNpkm88GwuowfVK5iCnqHqgt6DoqhSlIZL6wLnzaxEo
         l7GHxlIXiKXLAyzaCq+1h4vt9yTkX1DL1eO5E=
Message-ID: <4BDE9693.1090302@gmail.com>
Date: Mon, 03 May 2010 11:25:39 +0200
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; cs-CZ; rv:1.9.2.2pre) Gecko/20100308 SUSE/3.1b1-6.6 Thunderbird/3.1b1
MIME-Version: 1.0
To: Jiri Slaby <jslaby@suse.cz>
CC: Avi Kivity <avi@redhat.com>, Changli Gao <xiaosuo@gmail.com>,
       Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>,
       akpm@linux-foundation.org, paulmck@linux.vnet.ibm.com,
       adobriyan@gmail.com, mingo@elte.hu, peterz@infradead.org,
       linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] fs: use kmalloc() to allocate fdmem if possible
References: <viro@zeniv.linux.org.uk> <1272818776-7729-1-git-send-email-xiaosuo@gmail.com> 	<4BDDB6E9.4060703@redhat.com> <201005030915.FCD09385.FFHVOMJtSLOFQO@I-love.SAKURA.ne.jp> 	<4BDE67DA.4080004@redhat.com> <y2z412e6f7f1005030005vc3be4977z3add08bfc72d1c44@mail.gmail.com> 	<4BDE7E66.8030509@redhat.com> <m2l412e6f7f1005030052ka39a33ceke8c6b61553ba007f@mail.gmail.com> <4BDE8E24.5050200@redhat.com> <4BDE914C.6080504@suse.cz> <4BDE94C8.9000108@redhat.com> <4BDE95F2.1020506@suse.cz>
In-Reply-To: <4BDE95F2.1020506@suse.cz>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/03/2010 11:22 AM, Jiri Slaby wrote:
> When you get a slub in the middle of page

What I was thinking about? I meant when you get a piece of memory from
slab allocator which is in the middle of a page.

