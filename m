Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752664Ab0LQGPT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Dec 2010 01:15:19 -0500
Received: from mail-fx0-f43.google.com ([209.85.161.43]:53541 "EHLO
	mail-fx0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752294Ab0LQGPS convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Dec 2010 01:15:18 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=smeFLowT7/NZEgqkUBZZj+X5W7V0kycczwgfoaQtRoaT6jbMT8LQNd/Pire97xR4df
         8t5TE+3z7oNxv9ZnwueylsTm8hPDLfrh/GOXgRNE+Ipc8zzMARXE4S9MjWcJ28uhR340
         sGinD1smHxJVxaMDDT+JH8JwApiPGGirGSpKU=
MIME-Version: 1.0
In-Reply-To: <1292475627.2603.39.camel@edumazet-laptop>
References: <cover.1292405004.git.fenghua.yu@intel.com>
	<46a08278c2ba21737528eb4b77391a7e8bc88000.1292405004.git.fenghua.yu@intel.com>
	<1292446118.2603.11.camel@edumazet-laptop>
	<AANLkTikc+QTPH2He=fKgWiRGk=6sn9Phaa259YdkQNix@mail.gmail.com>
	<1292475627.2603.39.camel@edumazet-laptop>
Date: Fri, 17 Dec 2010 14:15:16 +0800
Message-ID: <AANLkTimmt9Y9aLNXU7=hOKvgEenkw2bsb43QBenM0YSE@mail.gmail.com>
Subject: Re: [PATCH 1/3] Kernel interfaces for multiqueue aware socket
From: Junchang Wang <junchangwang@gmail.com>
To: Eric Dumazet <eric.dumazet@gmail.com>
Cc: Fenghua Yu <fenghua.yu@intel.com>, "David S. Miller" <davem@davemloft.net>,
        John Fastabend <john.r.fastabend@intel.com>,
        Xinan Tang <xinan.tang@intel.com>, netdev <netdev@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 16, 2010 at 1:00 PM, Eric Dumazet <eric.dumazet@gmail.com> wrote:
> Le jeudi 16 décembre 2010 à 09:52 +0800, Junchang Wang a écrit :
>> Commit 564824b0c52c34692d had been used in the experiments, but the problem
>> remained unsolved.
>>
>> SLUB was used, and both servers were equipped with 8G physical memory.
>> Is there any
>> additional information I can provide?
>>
>
> Yes, sure, you could provide a description of the bench you used, and
> data you gathered to make the conclusion that NUMA was a problem.
>
Under the current circumstances (1Mpps), we can hardly see side effects
from memory allocator. With higher speed (say, 5Mpps with this patch set),
the problem emerged.

I'll continue this work after the patch set is done.


Thanks.
-- 
--Junchang
