Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935378Ab0GSOv1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Jul 2010 10:51:27 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:60444 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935027Ab0GSOv0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Jul 2010 10:51:26 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:subject:references
         :in-reply-to:x-enigmail-version:content-type
         :content-transfer-encoding;
        b=K5ppjCPUifHM5VVJp55JdwuTUcFuV0GJ4ccngiqMLF8q8IpOz0p8mnBLP6xAUqPDgm
         SdUTI0Qq3wstII7UJ+Fd1b53shbTPcYyupPYaUeFOHVvY1IYm3+g4UnIUy4cXZehy7tK
         Yi+Rl2p3wqejKPC/A3Mtlkyb8RVKrR8Yn8uQw=
Message-ID: <4C446667.6010306@gmail.com>
Date: Mon, 19 Jul 2010 16:51:19 +0200
From: Tejun Heo <htejun@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-US; rv:1.9.2.4) Gecko/20100608 Thunderbird/3.1
MIME-Version: 1.0
To: torvalds@linux-foundation.org, mingo@elte.hu, linux-kernel@vger.kernel.org,
        jeff@garzik.org, akpm@linux-foundation.org, rusty@rustcorp.com.au,
        cl@linux-foundation.org, dhowells@redhat.com, arjan@linux.intel.com,
        oleg@redhat.com, axboe@kernel.dk, fweisbec@gmail.com,
        dwalker@codeaurora.org, stefanr@s5r6.in-berlin.de, florian@mickler.org,
        andi@firstfloor.org, mst@redhat.com, randy.dunlap@oracle.com
Subject: Re: [PATCHSET] workqueue: concurrency managed workqueue, take#6
References: <1277759063-24607-1-git-send-email-tj@kernel.org>
In-Reply-To: <1277759063-24607-1-git-send-email-tj@kernel.org>
X-Enigmail-Version: 1.1.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/28/2010 11:03 PM, Tejun Heo wrote:
> Hello, all.
> 
> This is the sixth take of cmwq (concurrency managed workqueue)
> patchset.  It's on top of v2.6.35-rc3 + sched/core branch.  Git tree
> is available at
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/tj/wq.git review-cmwq

Pushed out to linux-next.

Thanks.

-- 
tejun
