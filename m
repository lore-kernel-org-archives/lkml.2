Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758839Ab0EMOtu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 May 2010 10:49:50 -0400
Received: from mail-pv0-f174.google.com ([74.125.83.174]:58568 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756219Ab0EMOtr convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 May 2010 10:49:47 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=uIWsfu5uNsoFIou+P6x5zzLaSz9FNUO2G5mEiRXT+G1B6/zMrcW60f9z0HlgpuQO5Q
         7CapEwhJFsof3fUmBzPfJiNNRLb4WwO+XaNC3tzVdVcyRFqBCAz0atY7cIVa5U15K64w
         vtMOwWcBTgS8lYC3hssMwDesDFm1VrF+1Fjbg=
MIME-Version: 1.0
In-Reply-To: <1273761576_4060@mail4.comsite.net>
References: <1273744285-8128-1-git-send-email-xiaosuo@gmail.com> 
	<1273761576_4060@mail4.comsite.net>
From: Changli Gao <xiaosuo@gmail.com>
Date: Thu, 13 May 2010 22:49:26 +0800
Message-ID: <AANLkTilanD4PlDpLqtTK7uE5o4aPgLhhYvYvVI37GycU@mail.gmail.com>
Subject: Re: [PATCH 1/9] mm: add generic adaptive large memory allocation APIs
To: Milton Miller <miltonm@bga.com>
Cc: akpm@linux-foundation.org, Hoang-Nam Nguyen <hnguyen@de.ibm.com>,
       Christoph Raisch <raisch@de.ibm.com>, Roland Dreier <rolandd@cisco.com>,
       Sean Hefty <sean.hefty@intel.com>,
       Hal Rosenstock <hal.rosenstock@gmail.com>,
       Divy Le Ray <divy@chelsio.com>,
       "James E.J. Bottomley" <James.Bottomley@suse.de>,
       "Theodore Ts'o" <tytso@mit.edu>, Andreas Dilger <adilger@sun.com>,
       Alexander Viro <viro@zeniv.linux.org.uk>,
       Paul Menage <menage@google.com>, Li Zefan <lizf@cn.fujitsu.com>,
       linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org,
       netdev@vger.kernel.org, linux-scsi@vger.kernel.org,
       linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       linux-mm@kvack.org, containers@lists.linux-foundation.org,
       Eric Dumazet <eric.dumazet@gmail.com>,
       Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>,
       Peter Zijlstra <peterz@infradead.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 13, 2010 at 10:39 PM, Milton Miller <miltonm@bga.com> wrote:
> On Thu, 13 May 2010 at 17:51:25 +0800, Changli Gao wrote:
>
>> +static inline void *kvcalloc(size_t n, size_t size)
>> +{
>> +     return __kvmalloc(n * size, __GFP_ZERO);
>>
>
> This needs multiply overflow checking like kcalloc.
>

Thanks.

-- 
Regards，
Changli Gao(xiaosuo@gmail.com)
