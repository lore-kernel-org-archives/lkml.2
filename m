Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754890Ab1DWOkr (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Apr 2011 10:40:47 -0400
Received: from mail-qy0-f174.google.com ([209.85.216.174]:38497 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754695Ab1DWOkp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Apr 2011 10:40:45 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=I2kQo7rcWQTwy5NQImB4vllAO8LfWDgVjVGCUyVjBmR0g6bBiA5xpLMrzyLGcdGZG6
         zZiYbL5gGTekGUxsU/anln16/d85bvGHfpJoz1ui0aXzIeiEx7hlFe3P/BTScAOh8TY6
         Bv06UNzxHrZpSS4Cju2MaKXtXxFpUQN/pV6H0=
MIME-Version: 1.0
In-Reply-To: <1303541890-14528-1-git-send-email-jipeng2005@gmail.com>
References: <1303541890-14528-1-git-send-email-jipeng2005@gmail.com>
Date: Sat, 23 Apr 2011 16:40:44 +0200
Message-ID: <BANLkTinYzLJAPdpNsZYuDML0eszgw00JcQ@mail.gmail.com>
Subject: Re: [PATCH 1/1] libata: ahci_start_engine compliant to AHCI spec
From: Tejun Heo <htejun@gmail.com>
To: Jian Peng <jipeng2005@gmail.com>
Cc: Jeff Garzik <jgarzik@pobox.com>, linux-ide@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Apr 23, 2011 at 8:58 AM, Jian Peng <jipeng2005@gmail.com> wrote:
> At the end of section 10.1 of AHCI spec (rev 1.3), it states
>
> Software shall not set PxCMD.ST to 1 until it is determined that
> a functoinal device is present on the port as determined by
> PxTFD.STS.BSY=0, PxTFD.STS.DRQ=0 and PxSSTS.DET=3h
>
> Even though most AHCI host controller works without this check,
> specific controller will fail under this condition.
>
> Signed-off-by: Jian Peng <jipeng2005@gmail.com>

Acked-by: Tejun Heo <tj@kernel.org>

Thanks.

-- 
tejun
