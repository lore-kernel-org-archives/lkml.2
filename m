Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755468Ab2IUGH7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Sep 2012 02:07:59 -0400
Received: from mx1.fusionio.com ([66.114.96.30]:60541 "EHLO mx1.fusionio.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751808Ab2IUGH5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Sep 2012 02:07:57 -0400
X-ASG-Debug-ID: 1348207676-03d6a52add1a6b30001-xx1T2L
X-Barracuda-Envelope-From: JAxboe@fusionio.com
Message-ID: <505C0438.9060907@fusionio.com>
Date: Fri, 21 Sep 2012 08:07:52 +0200
From: Jens Axboe <jaxboe@fusionio.com>
MIME-Version: 1.0
To: "Eric W. Biederman" <ebiederm@xmission.com>
CC: "linux-security-module@vger.kernel.org" 
	<linux-security-module@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Serge Hallyn <serge@hallyn.com>,
        Linux Containers <containers@lists.linux-foundation.org>
Subject: Re: [PATCH 01/14] userns: Convert loop to use kuid_t instead of uid_t
References: <87k3vote43.fsf@xmission.com> <1348187330-6616-1-git-send-email-ebiederm@xmission.com>
X-ASG-Orig-Subj: Re: [PATCH 01/14] userns: Convert loop to use kuid_t instead of uid_t
In-Reply-To: <1348187330-6616-1-git-send-email-ebiederm@xmission.com>
X-Enigmail-Version: 1.4.4
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Barracuda-Connect: mail1.int.fusionio.com[10.101.1.21]
X-Barracuda-Start-Time: 1348207676
X-Barracuda-Encrypted: AES128-SHA
X-Barracuda-URL: http://10.101.1.180:8000/cgi-mod/mark.cgi
X-Barracuda-Bayes: INNOCENT GLOBAL 0.0000 1.0000 -2.0210
X-Barracuda-Spam-Score: -2.02
X-Barracuda-Spam-Status: No, SCORE=-2.02 using per-user scores of TAG_LEVEL=1000.0 QUARANTINE_LEVEL=1000.0 KILL_LEVEL=9.0 tests=BSF_SC0_MISMATCH_TO
X-Barracuda-Spam-Report: Code version 3.2, rules version 3.2.2.109145
	Rule breakdown below
	 pts rule name              description
	---- ---------------------- --------------------------------------------------
	0.00 BSF_SC0_MISMATCH_TO    Envelope rcpt doesn't match header
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2012-09-21 02:28, Eric W. Biederman wrote:
> From: "Eric W. Biederman" <ebiederm@xmission.com>
> 
> Cc: Signed-off-by: Jens Axboe <jaxboe@fusionio.com>
> Acked-by: Serge Hallyn <serge.hallyn@canonical.com>
> Signed-off-by: Eric W. Biederman <ebiederm@xmission.com>
> ---
>  drivers/block/loop.c |    4 ++--
>  include/linux/loop.h |    2 +-
>  init/Kconfig         |    1 -
>  3 files changed, 3 insertions(+), 4 deletions(-)

Thanks Eric, queued for 3.7.

-- 
Jens Axboe

