Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756664Ab1F0GAe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Jun 2011 02:00:34 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:54306 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756142Ab1F0F7Y convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Jun 2011 01:59:24 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:from:date
         :x-google-sender-auth:message-id:subject:to:cc:content-type
         :content-transfer-encoding;
        b=RrRsxoRCEKX7prxxkCJ+GOoyQurlsD1z0PfOvIKT7t7mFWGzRTwxw/IGN7g5ZzWz3j
         3MJRb/mPNZMQQyshkrbz8kdyHdv7i6H224g9RYgcsdds5jPdoRQklDpCSkArsmFkdlzo
         fLPbeNg25MrV2BN31HXgi24ShZvgITAayPJKM=
MIME-Version: 1.0
In-Reply-To: <BANLkTikX-fYqG+1118UmzkAMQc1TSvG+qw@mail.gmail.com>
References: <1309039804-659-1-git-send-email-bryan.wu@canonical.com> <BANLkTikX-fYqG+1118UmzkAMQc1TSvG+qw@mail.gmail.com>
From: Bryan Wu <bryan.wu@canonical.com>
Date: Mon, 27 Jun 2011 13:59:03 +0800
X-Google-Sender-Auth: 2WtH5MpYSV2nehkCHcGsMqfniQ4
Message-ID: <BANLkTin9oYLORBKrOgnyaxHRM9TMHKyXLA@mail.gmail.com>
Subject: Re: [PATCH 0/4] Introduce a led trigger for CPU activity
To: Linus Walleij <linus.ml.walleij@gmail.com>
Cc: rpurdie@rpsys.net, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jun 26, 2011 at 7:02 PM, Linus Walleij
<linus.ml.walleij@gmail.com> wrote:
> 2011/6/26 Bryan Wu <bryan.wu@canonical.com>:
>
>> Based on Linus Walleij's ARM LED consolidation work, this patchset introduce a
>> new generic led trigger for CPU not only for ARM but also for others.
>
> Aha like that, OK I buy it. Just a few comments before I ACK it!
>

Thanks, man. I will prepare an updated consolidation patchset soon.

-- 
Bryan Wu <bryan.wu@canonical.com>
Kernel Developer    +86.138-1617-6545 Mobile
Ubuntu Kernel Team
Canonical Ltd.      www.canonical.com
Ubuntu - Linux for human beings | www.ubuntu.com
