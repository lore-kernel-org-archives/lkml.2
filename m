Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757896Ab0GBIcx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Jul 2010 04:32:53 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:60727 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757539Ab0GBIcu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Jul 2010 04:32:50 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:subject:references
         :in-reply-to:content-type:content-transfer-encoding;
        b=SQY/tgCXb9AfinD8HH7JXp1SuUzS9qEVxROny56ylOxlhf/k4NNHblAvZwiNVjGEGy
         jZlKOkPj0txEQJsiWfTDvZlDdcocBSeV3jsK7yu7smh4XoZaLoKZE3fSWzG9e/Yhpjq0
         ICe9pYP++Ifm5hk8YplkMgJuFEVcwjh//FsvY=
Message-ID: <4C2DA42C.7090804@gmail.com>
Date: Fri, 02 Jul 2010 10:32:44 +0200
From: Tejun Heo <htejun@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-US; rv:1.9.1.10) Gecko/20100512 Thunderbird/3.0.5
MIME-Version: 1.0
To: torvalds@linux-foundation.org, mingo@elte.hu, linux-kernel@vger.kernel.org,
       jeff@garzik.org, akpm@linux-foundation.org, rusty@rustcorp.com.au,
       cl@linux-foundation.org, dhowells@redhat.com, arjan@linux.intel.com,
       oleg@redhat.com, axboe@kernel.dk, fweisbec@gmail.com,
       dwalker@codeaurora.org, stefanr@s5r6.in-berlin.de, florian@mickler.org,
       andi@firstfloor.org, mst@redhat.com, randy.dunlap@oracle.com
Subject: [PATCHSET] workqueue: fixes on top of cmwq take#6
References: <1277759063-24607-1-git-send-email-tj@kernel.org>
In-Reply-To: <1277759063-24607-1-git-send-email-tj@kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

Commits for cmwq proper (patches 0001-0032) are now permanent.

  git://git.kernel.org/pub/scm/linux/kernel/git/tj/wq.git cmwq-core

These four patches fix bugs found since take#6 and available in the
following branch.

  git://git.kernel.org/pub/scm/linux/kernel/git/tj/wq.git for-next-candidate

Thanks.

--
tejun
