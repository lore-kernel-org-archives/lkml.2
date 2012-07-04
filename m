Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933743Ab2GDHyp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jul 2012 03:54:45 -0400
Received: from mail-gg0-f174.google.com ([209.85.161.174]:62969 "EHLO
	mail-gg0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933681Ab2GDHyn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jul 2012 03:54:43 -0400
MIME-Version: 1.0
In-Reply-To: <4FF3F603.6080401@ahsoftware.de>
References: <20120612162629.15519f39@feng-i7> <1341297347-19336-1-git-send-email-holler@ahsoftware.de>
 <CAK5ve-JCEeuhmqB=ruy78nCgma7ENL-48N+p5=nhz3e0exS9yg@mail.gmail.com>
 <4FF3EC87.4090001@ahsoftware.de> <CAK5ve-LZdCtUC3inX9S-UGwHBLxS-hqLmmUBOkTBn-9Z--7oPw@mail.gmail.com>
 <4FF3F603.6080401@ahsoftware.de>
From: Bryan Wu <bryan.wu@canonical.com>
Date: Wed, 4 Jul 2012 15:54:22 +0800
X-Google-Sender-Auth: 3TX4NJuJqc6pL-RlPK7i5s_hfbM
Message-ID: <CAK5ve-JkgxptE7G_iFBkif8ofAPjh2qXYwH=GcMheGO9Wwpnjw@mail.gmail.com>
Subject: Re: [PATCH] leds: heartbeat: fix bug on panic
To: Alexander Holler <holler@ahsoftware.de>
Cc: linux-kernel@vger.kernel.org, Shuah Khan <shuahkhan@gmail.com>,
        Richard Purdie <rpurdie@rpsys.net>, Feng Tang <feng.tang@intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 4, 2012 at 3:51 PM, Alexander Holler <holler@ahsoftware.de> wrote:
> Am 04.07.2012 09:29, schrieb Bryan Wu:
>
>
>> Anyway, I will apply this patch to my for-next branch.
>
>
> Is it already too late for 3.5 (where I introduced the bug)? I know I should
> have reacted faster, but I the bug report got down under a ton of other
> mails. ;)
>

OK, I will put it to my fixes-for-3.5 branch, since this is a real bug fixing.

Thanks,
-- 
Bryan Wu <bryan.wu@canonical.com>
Kernel Developer    +86.186-168-78255 Mobile
Canonical Ltd.      www.canonical.com
Ubuntu - Linux for human beings | www.ubuntu.com
