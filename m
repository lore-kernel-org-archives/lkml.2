Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757215Ab0DFVuW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Apr 2010 17:50:22 -0400
Received: from mail-qy0-f179.google.com ([209.85.221.179]:64095 "EHLO
	mail-qy0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752381Ab0DFVuR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Apr 2010 17:50:17 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=MdGeqcpcbYHI472Tio5BdapmDDjfBYIKRfd1C1KxtDj1mFibopVEDtYxqZmWLptOm6
         aJxx/rnnh7n+aIIwfQ0K//tGH/EAZ5TCLPC1/3QZH0yswpj3GpDBr5cYRWSmQ2AFaJFS
         zRQYS9MYPCKZVEUGbaIcszj4GZpw+mFvOlZ/g=
Message-ID: <4BBBAD61.2070009@gmail.com>
Date: Wed, 07 Apr 2010 06:53:37 +0900
From: Tejun Heo <htejun@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-US; rv:1.9.1.9) Gecko/20100317 Thunderbird/3.0.4
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: lkml <linux-kernel@vger.kernel.org>,
       Stephen Rothwell <sfr@canb.auug.org.au>,
       Andrew Morton <akpm@linux-foundation.org>,
       Pekka Enberg <penberg@cs.helsinki.fi>,
       Christoph Lameter <cl@linux-foundation.org>,
       Ingo Molnar <mingo@elte.hu>, Lee Schermerhorn <Lee.Schermerhorn@hp.com>,
       Alexey Dobriyan <adobriyan@gmail.com>
Subject: Re: [GIT PULL] break implicit percpu.h -> slab.h dependency
References: <4BB95DEE.3050607@kernel.org>
In-Reply-To: <4BB95DEE.3050607@kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus, can you please pull once more from the slabh branch?

  git://git.kernel.org/pub/scm/linux/kernel/git/tj/misc.git slabh

It has the following single fix for build failure spotted by Ingo
during -tip testing.

Thanks.

Tejun Heo (1):
      nodemask: include slab.h from drivers/base/node.c

 drivers/base/node.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

-- 
tejun
