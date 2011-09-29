Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756164Ab1I2MoB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Sep 2011 08:44:01 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:47215 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754512Ab1I2Mn7 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Sep 2011 08:43:59 -0400
MIME-Version: 1.0
In-Reply-To: <59872.1317299401@turing-police.cc.vt.edu>
References: <1317288548-19560-1-git-send-email-Barry.Song@csr.com> <59872.1317299401@turing-police.cc.vt.edu>
From: Barry Song <21cnbao@gmail.com>
Date: Thu, 29 Sep 2011 20:43:38 +0800
Message-ID: <CAGsJ_4znTLmjd_qhgru_aOZPMEZc=dyXEQTqdsVGKr-GaryQsQ@mail.gmail.com>
Subject: Re: [PATCH] PM: HIBERNATION: add resume_wait param to support
 MMC-like devices as resume file
To: Valdis.Kletnieks@vt.edu
Cc: Barry Song <Barry.Song@csr.com>, frank.hofmann@tomtom.com,
        linux-mmc@vger.kernel.org, linux-kernel@vger.kernel.org,
        workgroup.linux@csr.com, rjw@sisk.pl, pavel@ucw.cz,
        Barry Song <baohua.song@csr.com>, linux-pm@lists.linux-foundation.org,
        linux-arm-kernel@lists.infradead.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

hi Valdis,

2011/9/29  <Valdis.Kletnieks@vt.edu>:
> On Thu, 29 Sep 2011 02:29:08 PDT, Barry Song said:
>
>> This patch adds resumewait kernel param just like rootwait so
>> that we have enough time to wait mmc ready. The differene is
>> here we wait for resume partition but rootwait waits for rootfs
>> partition.
>
> OK, seems a reasonable idea...
>
>> kernel/power/hibernate.c |   16 ++++++++++++++++
>> 1 files changed, 16 insertions(+), 0 deletions(-)
>
> We have a __setup() parameter, this patch appears to be missing
> a hunk for Documentation/kernel-parameters.txt?
>
> Fix that issue, and you can stick this on there:
>
> Reviewed-by: Valdis Kletnieks <valdis.kletnieks@vt.edu>

thanks. i'll add the document in v2.

-barry
