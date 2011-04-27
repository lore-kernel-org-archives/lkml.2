Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756478Ab1D0Qbt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Apr 2011 12:31:49 -0400
Received: from mo-p00-ob.rzone.de ([81.169.146.162]:32805 "EHLO
	mo-p00-ob.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752992Ab1D0Qbs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Apr 2011 12:31:48 -0400
X-RZG-AUTH: :P2EQZWCpfu+qG7CngxMFH1J+zrwiavkK6tmQaLfmztM8TOFJhy0PFl+z
X-RZG-CLASS-ID: mo00
Date: Wed, 27 Apr 2011 18:31:43 +0200
From: Olaf Hering <olaf@aepfle.de>
To: stable@kernel.org
Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>, dtor@mail.ru,
        xen-devel@lists.xensource.com, linux-kernel@vger.kernel.org,
        Igor Mammedov <imammedo@redhat.com>
Subject: Re: [Xen-devel] [PATCH] [PV Xen] Mouse stuck after save/restore of
 guest. - stable tree candidate.
Message-ID: <20110427163143.GA32371@aepfle.de>
References: <1302795907-321-1-git-send-email-imammedo@redhat.com>
 <20110414155915.GA23629@dumpdata.com>
 <20110414172649.GA7569@aepfle.de>
 <20110414183804.GB1467@dumpdata.com>
 <20110415093737.GA15122@aepfle.de>
 <20110420182941.GA3148@dumpdata.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20110420182941.GA3148@dumpdata.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 20, Konrad Rzeszutek Wilk wrote:

> Hello stable-tree maintainers.
> 
> Please apply the upstream git commit c36b58e8a9112017c2bcc322cc98e71241814303
> (Input: xen-kbdfront - fix mouse getting stuck after save/restore)
> which fixes a regression introduced by 8c3c283e6bf463ab498d6e7823aff6c4762314b6
> (Input: xen-kbdfront - advertise either absolute or relative coordinates)
> 
> The 2.6.38 and 2.6.37 tree both contain the regression.

I checked which trees contain the broken commit from mainline:

broken stable trees:
2.6.38
http://git.kernel.org/?p=linux/kernel/git/stable/linux-2.6.38.y.git;a=commit;h=5ea5254aa0ad269cfbd2875c973ef25ab5b5e9db
2.6.37
http://git.kernel.org/?p=linux/kernel/git/stable/linux-2.6.37.y.git;a=commit;h=723517a796adf59f9ae628629fcb606c4cec8715
2.6.35
http://git.kernel.org/?p=linux/kernel/git/longterm/linux-2.6.35.y.git;a=commit;h=b88505e58ce6d36732cd15841cc821f97efca9bb
2.6.33
http://git.kernel.org/?p=linux/kernel/git/longterm/linux-2.6.33.y.git;a=commit;h=6997348a861d3540085bf9adf4166b86ac7a96e5
2.6.32
http://git.kernel.org/?p=linux/kernel/git/longterm/linux-2.6.32.y.git;a=commit;h=95e7148d08d0578687ea26cd3a8925aa5f7bc8fa
2.6.27
Does not have a variant of 8c3c283e6bf463ab498d6e7823aff6c4762314b6, yet.

So please apply upstream commit c36b58e8a9112017c2bcc322cc98e71241814303
to 2.6.38, 2.6.37, 2.6.35, 2.6.33 and 2.6.32 to fix the introduced
regression.


Thanks.

Olaf
