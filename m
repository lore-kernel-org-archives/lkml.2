Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754146Ab0GIBS3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Jul 2010 21:18:29 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:47887 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751436Ab0GIBS1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Jul 2010 21:18:27 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=FrGeX14tvlq8HgYOmoHbn72Ypg614pXQSm0TWm9YIqBMutH1hG7tiTaBmy0rWr7QCT
         eL4TnykHr/52KAMJsYj1WLVyUh07AaxgMccLCovDIgqFrjafo8EWha0PIJPSeuSULqt1
         yILbWEoISPvJY701Wnc4Fty91MZq2p9R/dQBY=
Message-ID: <4C367930.9000107@lwfinger.net>
Date: Thu, 08 Jul 2010 20:19:44 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.4) Gecko/20100608 SUSE/3.1.0 Thunderbird/3.1
MIME-Version: 1.0
To: "Rafael J. Wysocki" <rjw@sisk.pl>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Maciej Rutecki <maciej.rutecki@gmail.com>, Jens Axboe <axboe@kernel.dk>
Subject: Re: [Bug #16122] 2.6.35-rc1: WARNING at fs/fs-writeback.c:1142 __mark_inode_dirty+0x103/0x170
References: <-IGZ64uxA6G.A.P0H.bLmNMB@chimera> <TXb9XdQzJoD.A.TQE.dOmNMB@chimera>
In-Reply-To: <TXb9XdQzJoD.A.TQE.dOmNMB@chimera>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/08/2010 06:33 PM, Rafael J. Wysocki wrote:
> This message has been generated automatically as a part of a summary report
> of recent regressions.
>
> The following bug entry is on the current list of known regressions
> from 2.6.34.  Please verify if it still should be listed and let the tracking team
> know (either way).
>
>
> Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=16122
> Subject		: 2.6.35-rc1: WARNING at fs/fs-writeback.c:1142 __mark_inode_dirty+0x103/0x170
> Submitter	: Larry Finger<Larry.Finger@lwfinger.net>
> Date		: 2010-06-04 13:18 (35 days old)
> Handled-By	: Jens Axboe<axboe@kernel.dk>

This bug is still present in 2.6.35-rc4.

Larry
